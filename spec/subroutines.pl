
sub true_sub {
    return true;
}
 
sub false_sub {
    return false;
}

sub a_sub {
    return 1;
}

sub array_sub{
    return [1,2,3];
}

sub integer_sub{
    return 42;
}

sub string_sub {
    return "Hello World";
}

sub particular_array_sub{
    return [1,1,2,3,5,8];
}

sub hash_sub {
    return { 1 => "One", 2 => "Two", 3 => [1,2,3], "Four" => 1};
}

sub int_return_sub{
    my $int = pop(@_);
    if ($int == 1){
        return 1;
    } elsif ($int == 2) {
        return 2;
    }
    return [1,2];
}

1;