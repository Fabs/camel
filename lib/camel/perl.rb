class Perl

  attr_accessor :subroutines

  def initialize(source)
    @generated = false
    @perl_file = source
    @requires = [@perl_file] 
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

  def call(subroutine,*args)
    if not @subroutines.member?(subroutine) 
      raise UndefinedSubRoutine.new, "can't find '#{subroutine}' perl method"
    else
      generate() unless @generated
      open("/tmp/_args.yaml",'w') do | file | 
        if args.size == 1
          YAML.dump(args.first,file)
        else
          YAML.dump(args,file)          
        end
      end
      system("perl /tmp/_binding.pl #{@perl_file} #{subroutine}")
      data = open('/tmp/_subroutines.yaml') { |file| YAML.load(file) }
      return data;
    end
  end

  def sourceExists?
    File.exist?(@perl_file)
  end

  def mock(file)
    @requires << file
  end

  private 

  def generate
    requires = "require '"+@requires.join("';\nrequire '")+"';"
    code = [
    "use YAML;",
    "use YAML::Syck;",
    "$YAML::Syck::ImplicitTyping = 1;",
    requires,
    "sub run{",
    "\tmy ($file, $routine) = @_;",
    "\topen(YAMLFILE,\">/tmp/_subroutines.yaml\");",
    "\tmy @args = YAML::Syck::LoadFile('/tmp/_args.yaml');",
    "\tmy $result = &$routine(@args);",
    "\tprint YAMLFILE YAML::Dump($result);",
    "\tclose(YAMLFILE);",
    "}",
    "",
    "run(@ARGV[0],@ARGV[1])"
    ]
  
    file = File.open("/tmp/_binding.pl",'w')
    code.each do | line |
      file.puts line
    end
    file.close()
    @generated = true
  end


end