use experimental 'class';
use HTML::TokeParser::Corinna::Token;
class HTML::TokeParser::Corinna::Token::Declaration : isa(HTML::TokeParser::Corinna::Token) {
    use HTML::TokeParser::Corinna::Policy;

    # ["D",  $text]
    field $to_string :param;
    method is_declaration {true}
    method to_string      {$to_string}
}

1;

__END__

=head1 NAME

HTML::TokeParser::Corinna::Token::Declaration - Token.pm declaration class.

=head1 SYNOPSIS

    use HTML::TokeParser::Corinna;
    my $p = HTML::TokeParser::Corinna->new( file => $somefile );

    while ( my $token = $p->get_token ) {
        # This prints all text in an HTML doc (i.e., it strips the HTML)
        next unless $token->is_text;
        print $token->as_is;
    }

=head1 DESCRIPTION

This is the declaration class for tokens. 

=head1 OVERRIDDEN METHODS

=head2 is_declaration

=cut
