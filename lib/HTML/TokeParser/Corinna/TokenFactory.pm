use v5.37.8;
use experimental 'class';
use HTML::TokeParser::Corinna::Base;
class HTML::TokeParser::Corinna::TokenFactory :isa(HTML::TokeParser::Corinna::Base) {
    use HTML::TokeParser::Corinna::Policy;

    use HTML::TokeParser::Corinna::Token;
    use HTML::TokeParser::Corinna::Token::Tag;
    use HTML::TokeParser::Corinna::Token::Tag::Start;
    use HTML::TokeParser::Corinna::Token::Tag::End;
    use HTML::TokeParser::Corinna::Token::Text;
    use HTML::TokeParser::Corinna::Token::Comment;
    use HTML::TokeParser::Corinna::Token::Declaration;
    use HTML::TokeParser::Corinna::Token::ProcessInstruction;

    field $_base :param = q(HTML::TokeParser::Corinna::Token);

    method S ($tag,$attr,$attrseq,$to_string) {
	my $class = "${_base}::Tag::Start";
	return $class->new( tag		=> $tag,
			    attr	=> { %$attr },
			    attrseq	=> [ @$attrseq ],
			    to_string	=> $to_string );
    }

    method E ($tag,$to_string) {
	my $class = "${_base}::Tag::End";
	return $class->new( tag		=> $tag,
			    to_string	=> $to_string );
    }

    method T ($to_string,$is_data = false) {
	my $class = "${_base}::Text";
	return $class->new( to_string	=> $to_string,
			    is_data	=> $is_data );
    }

    method C ($to_string) {
	my $class = "${_base}::Comment";
	return $class->new( to_string	=> $to_string );
    }

    method D ($to_string) {
	my $class = "${_base}::Declaration";
	return $class->new( to_string	=> $to_string );
    }

    method PI ($token0,$to_string) {
	my $class = "${_base}::ProcessInstruction";
	return $class->new ( token0	=> $token0,
			     to_string	=> $to_string );
    }
}

__END__

=head1 NAME

HTML::TokeParser::Corinna::TokenFactory - create token objects

=head1 SYNOPSIS

     use HTML::TokeParser;
     my $p = HTML::TokeParser::new( \$html_text );

     use HTML::TokeParser::Corinna::TokenFactory;
     my $factory = HTML::TokeParser::Corinna::TokenFactory->new;

     while ( my $token = $p->get_token ) {
         # This prints all text in an HTML doc (i.e., it strips the HTML)
	 my $factory_method = $token->[0];
         my $object = $factory->$factory_method($token->@[1..$token->$#*]);
         next unless $object->is_text;
         print $object->to_string;
     }	 

=head1 DESCRIPTION

This factory converts the tokens produced by L<HTML::TokeParser> into
token objects.  The method names and their signatures correspond
directly to the return value of L<HTML::TokeParser/$p-E<gt>get_token>:
The first element of the token arrays is used as a method.



=head1 METHODS

=head2 C<new()>

Builds a token factory.  Takes one named argument C<_base>: This name
will be used as a prefix for the classes used to build the tokens.
This intended for testing, so that the C<new> method of a set of fake
classes can be used to examine constructor arguments.

The default value for C<_base_> is C<'HTML::TokeParser::Corinna::Token'>,
as used in this TokeParser.

=head2 C<S>

The C<S> method creates objects representing start tags.
See L<HTML::TokeParser::Corinna::Token::Tag::Start>.

=head2 C<E>

The C<E> method creates objects representing end tags.
See L<HTML::TokeParser::Corinna::Token::Tag::End>.

=head2 C<T>

The C<T> method creates objects representing text.
See L<HTML::TokeParser::Corinna::Token::Text>.

=head2 C<C>

The C<T> method creates objects representing comments.
See L<HTML::TokeParser::Corinna::Token::Comment>.


=head2 C<D>

The C<T> method creates objects representing Declarations.
See L<HTML::TokeParser::Corinna::Token::Declaration>.


=head2 C<PI>

The C<T> method creates objects representing pricess instructions.
See L<HTML::TokeParser::Corinna::Token::ProcessInstruction>.
