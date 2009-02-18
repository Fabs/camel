class UndefinedSubRoutine < Exception
end

class Perl
  
  attr_accessor :subroutines
  
  def initialize(source)
    @generated = false
    @file_name = source
    if sourceExists?
      @source = File.open(source)
      @subroutines = []
      @source.each do | line |
        if line =~ (/^sub\s+((\w|_)+)\s*\{\s*$/)
          @subroutines <<  $1
        end
      end
   end
  end

  def call(subroutine)
    if not @subroutines.member?(subroutine) 
      raise UndefinedSubRoutine.new
    else
      generate() unless @generated
      system("perl lib/camel/binding.pl #{@file_name} #{subroutine}")
      data = open('subroutines.yaml') { |file| YAML.load(file) }
      system("rm subroutines.yaml")
      return data;
    end
  end
  
  def sourceExists?
    File.exist?(@file_name)
  end
  
  private 
  
  def generate
    code = [
    "use YAML;",
    "require 'spec/subroutines.pl';",
    "sub run{",
    "\tmy ($file, $routine) = @_;",
    "\topen(YAMLFILE,'>subroutines.yaml');",
    "\tprint YAMLFILE Dump(&$routine());",
    "\tclose(YAMLFILE);",
    "}",
    "",
    "run(@ARGV[0],@ARGV[1])"
    ]
    
    file = File.open("lib/camel/binding.pl",'w')
    code.each do | line |
      file.puts line
    end
    file.close()
    @generated = true
  end
  
  
end