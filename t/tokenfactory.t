#!/usr/bin/env perl
use 5.037;
use lib 'lib';
use Test::Most;
use HTML::TokeParser::Corinna::Utils 'throw';

use HTML::TokeParser::Corinna::TokenFactory;

my %values = (
    tag       => 'dog',
    attr      => { key => 'value', lockpick => 'works fine' },
    attrseq   => [ qw(key lockpick) ],
    to_string => 'some arbitrary text',
    is_data   => 1,
    token0    => 'no_token',
);

package XYZZY::Validator {
    use Test::Most;
    sub check_args ($class,$package,$count,%args) {
        is ($class,$package,
            "An Object of class '$class' is about to be created");
        is (scalar keys %args, $count,
            "Found $count named constructor arguments");
        for (sort keys %args) {
            is_deeply($args{$_},$values{$_},
                      "Argument '$_' is ok");
        }
    }
}
package XYZZY::Tag::Start {
    use parent -norequire, 'XYZZY::Validator';
    sub new ($class,%args) {
        $class->check_args(__PACKAGE__,4,%args);
    }
}
package XYZZY::Tag::End {
    use parent -norequire, 'XYZZY::Validator';
    sub new ($class,%args) {
        $class->check_args(__PACKAGE__,2,%args);
    }
}
package XYZZY::Text {
    use parent -norequire, 'XYZZY::Validator';
    sub new ($class,%args) {
        $class->check_args(__PACKAGE__,2,%args);
    }
}
package XYZZY::Comment {
    use parent -norequire, 'XYZZY::Validator';
    sub new ($class,%args) {
        $class->check_args(__PACKAGE__,1,%args);
    }
}
package XYZZY::Declaration {
    use parent -norequire, 'XYZZY::Validator';
    sub new ($class,%args) {
        $class->check_args(__PACKAGE__,1,%args);
    }
}
package XYZZY::ProcessInstruction {
    use parent -norequire, 'XYZZY::Validator';
    sub new ($class,%args) {
        $class->check_args(__PACKAGE__,2,%args);
    }
}

# This series of tests checks the mapping from positional
# arguments as provided in the arrayref token of HTML::TokeParser
# to the named parameters to be used to construct our token
# classes.
subtest 'Parameter list munging' => sub {
    my $factory = HTML::TokeParser::Corinna::TokenFactory->new(_base => 'XYZZY');
    $factory->S(@values{qw(tag attr attrseq to_string)});
    $factory->E(@values{qw(tag to_string)});
    $factory->T(@values{qw(to_string is_data)});
    $factory->C(@values{qw(to_string)});
    $factory->D(@values{qw(to_string)});
    $factory->PI(@values{qw(token0 to_string)});
};

# Now let's actually create the objects.
subtest 'Object creation' => sub {
    no warnings 'experimental::builtin';
    my $factory = HTML::TokeParser::Corinna::TokenFactory->new();
    {
        my $object = $factory->S(@values{qw(tag attr attrseq to_string)});
        my $class = builtin::blessed $object;
        is ($class,'HTML::TokeParser::Corinna::Token::Tag::Start',
            "An object of class '$class' has been returned");
    }
    {
        my $object = $factory->E(@values{qw(tag to_string)});
        my $class = builtin::blessed $object;
        is ($class,'HTML::TokeParser::Corinna::Token::Tag::End',
            "An object of class '$class' has been returned");
    }
    {
        my $object = $factory->T(@values{qw(to_string is_data)});
        my $class = builtin::blessed $object;
        is ($class,'HTML::TokeParser::Corinna::Token::Text',
            "An object of class '$class' has been returned");
    }
    {
        my $object = $factory->C(@values{qw(to_string)});
        my $class = builtin::blessed $object;
        is ($class,'HTML::TokeParser::Corinna::Token::Comment',
            "An object of class '$class' has been returned");
    }
    {
        my $object = $factory->D(@values{qw(to_string)});
        my $class = builtin::blessed $object;
        is ($class,'HTML::TokeParser::Corinna::Token::Declaration',
            "An object of class '$class' has been returned");
    }
    {
        my $object = $factory->PI(@values{qw(tag to_string)});
        my $class = builtin::blessed $object;
        is ($class,'HTML::TokeParser::Corinna::Token::ProcessInstruction',
            "An object of class '$class' has been returned");
    }
};
done_testing;
