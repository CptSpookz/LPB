grammar LPB;

@header {from antlr4.error.Errors import ParseCancellationException}
@lexer::members {
def erroLexico(self, msg):
    raise ParseCancellationException(msg)
}

programa: 'imovel' decl_imovel ':' corpo 'fim_imovel';

decl_imovel: decl_casa | decl_apartamento;

decl_casa: 'Casa' '(' 'Tam' num_blocos=dimensao ',' 'Andares' num_andares=dimensao ')';

decl_apartamento: 'Apartamento' '(' 'Tam' dimensao ')';

corpo: decl_andar+;

decl_andar: 'andar' NUM_INT ':' decl_planta? 'fim_andar';

decl_planta: 'planta' ':' decl_comodos+ decl_moveis* 'fim_planta';

decl_comodos: id_bloco 'tem' 'comodo' var_comodo (',' var_comodo)*;

decl_moveis: id_bloco '->' IDENT 'tem' 'movel' tipo_movel (',' tipo_movel)*;

id_bloco:  '{' NUM_INT '}';

var_comodo: IDENT tipo_comodo dimensao?;

tipo_comodo: 'cozinha' | 'quarto' | 'banheiro' | 'quintal' | 'escritorio' | 'garagem';

tipo_movel: 'sofa' | 'cama' | 'armario' | 'pia' | 'chuveiro' | 'televisao' | 'geladeira' | 'piscina';

dimensao: '[' NUM_INT ']';

NUM_INT: [0-9]+;

IDENT: [a-zA-Z]+;

ESPACO: [ \r\n\t]+ -> skip;

COMENT: '"' .*? '"' -> skip;

COMENT_N_FECHADO: '"' .*? { self.erroLexico("Linha {}:{} comentário não fechado.".format(self._tokenStartLine + 1, self._tokenStartColumn)) };

SIMB_DESCONHECIDO: . { self.erroLexico("Linha {}:{} {} - símbolo não identificado.".format(self._tokenStartLine, self._tokenStartColumn,
                                                                                   self._input.strdata[self._input._index-1])) };
