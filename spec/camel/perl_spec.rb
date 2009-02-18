require 'spec/spec_helper.rb'

require 'lib/camel/perl.rb'
require 'yaml'

describe "CamelPerlTester" do
  
  it "should complain if perl file not found" 
  
  before :each do
    @perl = Perl.new('spec/subroutines.pl')
    @no_perl = Perl.new('spec/subroutines_not_exists.pl')
  end
  
  
  it "should have a valid perl example file" do
    system("perl spec/subroutines.pl").should == true
  end
  
  it "should have an perl file" do
    @perl.sourceExists?.should == true
    @no_perl.sourceExists?.should == false
  end
  
  it "should find subroutines into the file" do
    @perl.subroutines.member?("a_sub").should == true
  end
  
  it "should call a subroutine, and complain if it do not exists" do
    lambda{@perl.call("a_sub")}.should_not raise_error
    lambda{@perl.call("no_sub")}.should raise_error(UndefinedSubRoutine)
  end
  
  it "should answer boolean types, and should not left any YAML" do
    @perl.call("true_sub").should == true
    @perl.call("false_sub").should == false
    File.exists?('subroutines.yaml').should == false    
  end
  
  it "should answer array types" do
    @perl.call("array_sub").should == [1,2,3]
  end
  
  it "should answer string types" do
    @perl.call("string_sub").should == "Hello World"
  end
  
  it "should answer integer types" do
    @perl.call("integer_sub").should == 42
  end
  
  it "should answer this particular array" do
    @perl.call("particular_array_sub").should == [1,1,2,3,5,8]
  end
  
  it "should answer hash types" do
    @perl.call("hash_sub").should == { 1 => "One", 2 => "Two", 3 => [1,2,3], "Four" => 1}
  end
        
  
end
