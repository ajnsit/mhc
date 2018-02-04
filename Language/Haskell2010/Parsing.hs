module  Language.Haskell2010.Parsing  where
import qualified Control.Monad as Monad


type Pos = (Int, Int)
type AS = Pos
type BACKQUOTE = Pos
type CLASS = Pos
type COLON_COLON = Pos
type COMMA = Pos
type DARROW = Pos
type DATA = Pos
type DEFAULT = Pos
type DERIVING = Pos
type DOT_DOT = Pos
type ELSE = Pos
type EQUAL = Pos
type EXCL = Pos
type EXPORT = Pos
type FOREIGN = Pos
type HIDING = Pos
type IMPORT = Pos
type IF = Pos
type IN = Pos
type INFIX = Pos
type INFIXL = Pos
type INFIXR = Pos
type INSTANCE = Pos
type INTEGER = (Pos, Integer)
type LAMBDA = Pos
type LARROW = Pos
type LBRACE = Pos
type LBRACKET = Pos
type LET = Pos
type LPAREN = Pos
type MINUS = Pos
type MODULE = Pos
type NEWTYPE = Pos
type PIPE = Pos
type QCONID = (Pos, String)
type QCONSYM = (Pos, String)
type QUALIFIED = Pos
type QVARID = (Pos, String)
type QVARSYM = (Pos, String)
type RBRACE = Pos
type RBRACKET = Pos
type RARROW = Pos
type RPAREN = Pos
type SEMICOLON = Pos
type STRING = (Pos, String)
type THEN = Pos
type TYPE = Pos
type WHERE = Pos

data Token =
    AS AS
  | BACKQUOTE BACKQUOTE
  | CLASS CLASS
  | COLON_COLON COLON_COLON
  | COMMA COMMA
  | DARROW DARROW
  | DATA DATA
  | DEFAULT DEFAULT
  | DERIVING DERIVING
  | DOT_DOT DOT_DOT
  | ELSE ELSE
  | EQUAL EQUAL
  | EXCL EXCL
  | EXPORT EXPORT
  | FOREIGN FOREIGN
  | HIDING HIDING
  | IF IF
  | IMPORT IMPORT
  | IN IN
  | INFIX INFIX
  | INFIXL INFIXL
  | INFIXR INFIXR
  | INSTANCE INSTANCE
  | INTEGER INTEGER
  | LAMBDA LAMBDA
  | LARROW LARROW
  | LBRACE LBRACE
  | LBRACKET LBRACKET
  | LET LET
  | LPAREN LPAREN
  | MINUS MINUS
  | MODULE MODULE
  | NEWTYPE NEWTYPE
  | PIPE PIPE
  | QCONID QCONID
  | QCONSYM QCONSYM
  | QUALIFIED QUALIFIED
  | QVARID QVARID
  | QVARSYM QVARSYM
  | RARROW RARROW
  | RBRACE RBRACE
  | RBRACKET RBRACKET
  | RPAREN RPAREN
  | SEMICOLON SEMICOLON
  | STRING STRING
  | THEN THEN
  | TYPE TYPE
  | WHERE WHERE
  deriving (Eq, Ord, Read, Show)

data Action = Shift Int | Reduce Int Int | Accept
type ActionState = Int
data ActionSymbol = Token Token | EOF
type GotoState = Int
type GotoSymbol = Int

data Module' =
    Module'_implies_MODULE_modid_exports_opt_WHERE_body MODULE Modid Exports_opt WHERE Body
  | Module'_implies_body Body
  deriving (Eq, Ord, Read, Show)

data Modid =
    Modid_implies_QCONID QCONID
  deriving (Eq, Ord, Read, Show)

data Exports_opt =
    Exports_opt_implies
  | Exports_opt_implies_exports Exports
  deriving (Eq, Ord, Read, Show)

data Body =
    Body_implies_LBRACE_topdecls_RBRACE LBRACE Topdecls RBRACE
  deriving (Eq, Ord, Read, Show)

data Topdecls =
    Topdecls_implies_topdecl Topdecl
  | Topdecls_implies_topdecl_SEMICOLON_topdecls Topdecl SEMICOLON Topdecls
  deriving (Eq, Ord, Read, Show)

data Exports =
    Exports_implies_LPAREN_export_seq_RPAREN LPAREN Export_seq RPAREN
  deriving (Eq, Ord, Read, Show)

data Export_seq =
    Export_seq_implies
  | Export_seq_implies_export Export
  | Export_seq_implies_export_COMMA_export_seq Export COMMA Export_seq
  deriving (Eq, Ord, Read, Show)

data Export =
    Export_implies_var Var
  | Export_implies_con Con
  | Export_implies_con_LPAREN_RPAREN Con LPAREN RPAREN
  | Export_implies_con_LPAREN_DOT_DOT_RPAREN Con LPAREN DOT_DOT RPAREN
  | Export_implies_con_LPAREN_cname_seq_RPAREN Con LPAREN Cname_seq RPAREN
  | Export_implies_MODULE_modid MODULE Modid
  deriving (Eq, Ord, Read, Show)

data Var =
    Var_implies_AS AS
  | Var_implies_EXPORT EXPORT
  | Var_implies_QVARID QVARID
  | Var_implies_LPAREN_MINUS_RPAREN LPAREN MINUS RPAREN
  | Var_implies_LPAREN_QVARSYM_RPAREN LPAREN QVARSYM RPAREN
  deriving (Eq, Ord, Read, Show)

data Con =
    Con_implies_QCONID QCONID
  | Con_implies_LPAREN_QCONSYM_RPAREN LPAREN QCONSYM RPAREN
  deriving (Eq, Ord, Read, Show)

data Cname_seq =
    Cname_seq_implies_cname Cname
  | Cname_seq_implies_cname_COMMA_cname_seq Cname COMMA Cname_seq
  deriving (Eq, Ord, Read, Show)

data Import_seq =
    Import_seq_implies
  | Import_seq_implies_import' Import'
  | Import_seq_implies_import'_COMMA_import_seq Import' COMMA Import_seq
  deriving (Eq, Ord, Read, Show)

data Import' =
    Import'_implies_var Var
  | Import'_implies_con Con
  | Import'_implies_con_LPAREN_RPAREN Con LPAREN RPAREN
  | Import'_implies_con_LPAREN_DOT_DOT_RPAREN Con LPAREN DOT_DOT RPAREN
  | Import'_implies_con_LPAREN_cname_seq_RPAREN Con LPAREN Cname_seq RPAREN
  deriving (Eq, Ord, Read, Show)

data Cname =
    Cname_implies_var Var
  | Cname_implies_con Con
  deriving (Eq, Ord, Read, Show)

data Topdecl =
    Topdecl_implies_IMPORT_qualified_opt_modid_as_opt IMPORT Qualified_opt Modid As_opt
  | Topdecl_implies_IMPORT_qualified_opt_modid_as_opt_LPAREN_import_seq_RPAREN IMPORT Qualified_opt Modid As_opt LPAREN Import_seq RPAREN
  | Topdecl_implies_IMPORT_qualified_opt_modid_as_opt_HIDING_LPAREN_import_seq_RPAREN IMPORT Qualified_opt Modid As_opt HIDING LPAREN Import_seq RPAREN
  | Topdecl_implies_TYPE_btype_EQUAL_type' TYPE Btype EQUAL Type'
  | Topdecl_implies_DATA_btype_constrs_opt DATA Btype Constrs_opt
  | Topdecl_implies_DATA_btype_constrs_opt_DERIVING_dclass DATA Btype Constrs_opt DERIVING Dclass
  | Topdecl_implies_DATA_btype_constrs_opt_DERIVING_LPAREN_RPAREN DATA Btype Constrs_opt DERIVING LPAREN RPAREN
  | Topdecl_implies_DATA_btype_constrs_opt_DERIVING_LPAREN_dclass_seq_RPAREN DATA Btype Constrs_opt DERIVING LPAREN Dclass_seq RPAREN
  | Topdecl_implies_DATA_btype_DARROW_btype_constrs_opt DATA Btype DARROW Btype Constrs_opt
  | Topdecl_implies_DATA_btype_DARROW_btype_constrs_opt_DERIVING_dclass DATA Btype DARROW Btype Constrs_opt DERIVING Dclass
  | Topdecl_implies_DATA_btype_DARROW_btype_constrs_opt_DERIVING_LPAREN_RPAREN DATA Btype DARROW Btype Constrs_opt DERIVING LPAREN RPAREN
  | Topdecl_implies_DATA_btype_DARROW_btype_constrs_opt_DERIVING_LPAREN_dclass_seq_RPAREN DATA Btype DARROW Btype Constrs_opt DERIVING LPAREN Dclass_seq RPAREN
  | Topdecl_implies_NEWTYPE_btype_newconstr NEWTYPE Btype Newconstr
  | Topdecl_implies_NEWTYPE_btype_newconstr_DERIVING_dclass NEWTYPE Btype Newconstr DERIVING Dclass
  | Topdecl_implies_NEWTYPE_btype_newconstr_DERIVING_LPAREN_RPAREN NEWTYPE Btype Newconstr DERIVING LPAREN RPAREN
  | Topdecl_implies_NEWTYPE_btype_newconstr_DERIVING_LPAREN_dclass_seq_RPAREN NEWTYPE Btype Newconstr DERIVING LPAREN Dclass_seq RPAREN
  | Topdecl_implies_NEWTYPE_btype_DARROW_btype_newconstr NEWTYPE Btype DARROW Btype Newconstr
  | Topdecl_implies_NEWTYPE_btype_DARROW_btype_newconstr_DERIVING_dclass NEWTYPE Btype DARROW Btype Newconstr DERIVING Dclass
  | Topdecl_implies_NEWTYPE_btype_DARROW_btype_newconstr_DERIVING_LPAREN_RPAREN NEWTYPE Btype DARROW Btype Newconstr DERIVING LPAREN RPAREN
  | Topdecl_implies_NEWTYPE_btype_DARROW_btype_newconstr_DERIVING_LPAREN_dclass_seq_RPAREN NEWTYPE Btype DARROW Btype Newconstr DERIVING LPAREN Dclass_seq RPAREN
  | Topdecl_implies_CLASS_btype_cdecls_opt CLASS Btype Cdecls_opt
  | Topdecl_implies_CLASS_btype_DARROW_btype_cdecls_opt CLASS Btype DARROW Btype Cdecls_opt
  | Topdecl_implies_INSTANCE_btype_idecls_opt INSTANCE Btype Idecls_opt
  | Topdecl_implies_INSTANCE_btype_DARROW_btype_idecls_opt INSTANCE Btype DARROW Btype Idecls_opt
  | Topdecl_implies_DEFAULT_LPAREN_RPAREN DEFAULT LPAREN RPAREN
  | Topdecl_implies_DEFAULT_LPAREN_type_seq_RPAREN DEFAULT LPAREN Type_seq RPAREN
  | Topdecl_implies_FOREIGN_fdecl FOREIGN Fdecl
  | Topdecl_implies_decl Decl
  deriving (Eq, Ord, Read, Show)

data Qualified_opt =
    Qualified_opt_implies
  | Qualified_opt_implies_QUALIFIED QUALIFIED
  deriving (Eq, Ord, Read, Show)

data As_opt =
    As_opt_implies
  | As_opt_implies_AS_modid AS Modid
  deriving (Eq, Ord, Read, Show)

data Btype =
    Btype_implies_atype Atype
  | Btype_implies_btype_atype Btype Atype
  deriving (Eq, Ord, Read, Show)

data Type' =
    Type'_implies_btype Btype
  | Type'_implies_btype_RARROW_type' Btype RARROW Type'
  deriving (Eq, Ord, Read, Show)

data Constrs_opt =
    Constrs_opt_implies
  | Constrs_opt_implies_EQUAL_constrs EQUAL Constrs
  deriving (Eq, Ord, Read, Show)

data Dclass =
    Dclass_implies_QCONID QCONID
  deriving (Eq, Ord, Read, Show)

data Dclass_seq =
    Dclass_seq_implies_dclass Dclass
  | Dclass_seq_implies_dclass_COMMA_dclass_seq Dclass COMMA Dclass_seq
  deriving (Eq, Ord, Read, Show)

data Newconstr =
    Newconstr_implies_EQUAL_con_atype EQUAL Con Atype
  | Newconstr_implies_EQUAL_con_LBRACE_var_COLON_COLON_type'_RBRACE EQUAL Con LBRACE Var COLON_COLON Type' RBRACE
  deriving (Eq, Ord, Read, Show)

data Cdecls_opt =
    Cdecls_opt_implies
  | Cdecls_opt_implies_WHERE_cdecls WHERE Cdecls
  deriving (Eq, Ord, Read, Show)

data Idecls_opt =
    Idecls_opt_implies
  | Idecls_opt_implies_WHERE_idecls WHERE Idecls
  deriving (Eq, Ord, Read, Show)

data Type_seq =
    Type_seq_implies_type' Type'
  | Type_seq_implies_type'_COMMA_type_seq Type' COMMA Type_seq
  deriving (Eq, Ord, Read, Show)

data Fdecl =
    Fdecl_implies_IMPORT_callconv_impent_var_COLON_COLON_type' IMPORT Callconv Impent Var COLON_COLON Type'
  | Fdecl_implies_IMPORT_callconv_safety_impent_var_COLON_COLON_type' IMPORT Callconv Safety Impent Var COLON_COLON Type'
  | Fdecl_implies_EXPORT_callconv_expent_var_COLON_COLON_type' EXPORT Callconv Expent Var COLON_COLON Type'
  deriving (Eq, Ord, Read, Show)

data Decl =
    Decl_implies_gendecl Gendecl
  | Decl_implies_pat_EQUAL_exp Pat EQUAL Exp
  | Decl_implies_pat_EQUAL_exp_WHERE_decls Pat EQUAL Exp WHERE Decls
  | Decl_implies_pat_PIPE_gdrhs Pat PIPE Gdrhs
  | Decl_implies_pat_PIPE_gdrhs_WHERE_decls Pat PIPE Gdrhs WHERE Decls
  deriving (Eq, Ord, Read, Show)

data Decls =
    Decls_implies_LBRACE_decl_seq_RBRACE LBRACE Decl_seq RBRACE
  deriving (Eq, Ord, Read, Show)

data Decl_seq =
    Decl_seq_implies_decl Decl
  | Decl_seq_implies_decl_SEMICOLON_decl_seq Decl SEMICOLON Decl_seq
  deriving (Eq, Ord, Read, Show)

data Gendecl =
    Gendecl_implies
  | Gendecl_implies_vars_COLON_COLON_type' Vars COLON_COLON Type'
  | Gendecl_implies_vars_COLON_COLON_btype_DARROW_type' Vars COLON_COLON Btype DARROW Type'
  | Gendecl_implies_fixity_integer_opt_ops Fixity Integer_opt Ops
  deriving (Eq, Ord, Read, Show)

data Pat =
    Pat_implies_apat Apat
  | Pat_implies_pat_apat Pat Apat
  | Pat_implies_pat_MINUS_apat Pat MINUS Apat
  | Pat_implies_pat_op_apat Pat Op Apat
  deriving (Eq, Ord, Read, Show)

data Exp =
    Exp_implies_infixexp Infixexp
  deriving (Eq, Ord, Read, Show)

data Gdrhs =
    Gdrhs_implies_guards_EQUAL_exp Guards EQUAL Exp
  | Gdrhs_implies_guards_EQUAL_exp_PIPE_gdrhs Guards EQUAL Exp PIPE Gdrhs
  deriving (Eq, Ord, Read, Show)

data Cdecls =
    Cdecls_implies_LBRACE_cdecl_seq_RBRACE LBRACE Cdecl_seq RBRACE
  deriving (Eq, Ord, Read, Show)

data Cdecl_seq =
    Cdecl_seq_implies_cdecl Cdecl
  | Cdecl_seq_implies_cdecl_SEMICOLON_cdecl_seq Cdecl SEMICOLON Cdecl_seq
  deriving (Eq, Ord, Read, Show)

data Cdecl =
    Cdecl_implies_gendecl Gendecl
  | Cdecl_implies_pat_EQUAL_exp Pat EQUAL Exp
  | Cdecl_implies_pat_EQUAL_exp_WHERE_decls Pat EQUAL Exp WHERE Decls
  | Cdecl_implies_pat_PIPE_gdrhs Pat PIPE Gdrhs
  | Cdecl_implies_pat_PIPE_gdrhs_WHERE_decls Pat PIPE Gdrhs WHERE Decls
  deriving (Eq, Ord, Read, Show)

data Idecls =
    Idecls_implies_LBRACE_idecl_seq_RBRACE LBRACE Idecl_seq RBRACE
  deriving (Eq, Ord, Read, Show)

data Idecl_seq =
    Idecl_seq_implies_idecl Idecl
  | Idecl_seq_implies_idecl_SEMICOLON_idecl_seq Idecl SEMICOLON Idecl_seq
  deriving (Eq, Ord, Read, Show)

data Idecl =
    Idecl_implies
  | Idecl_implies_pat_EQUAL_exp Pat EQUAL Exp
  | Idecl_implies_pat_EQUAL_exp_WHERE_decls Pat EQUAL Exp WHERE Decls
  | Idecl_implies_pat_PIPE_gdrhs Pat PIPE Gdrhs
  | Idecl_implies_pat_PIPE_gdrhs_WHERE_decls Pat PIPE Gdrhs WHERE Decls
  deriving (Eq, Ord, Read, Show)

data Vars =
    Vars_implies_var Var
  | Vars_implies_var_COMMA_vars Var COMMA Vars
  deriving (Eq, Ord, Read, Show)

data Fixity =
    Fixity_implies_INFIXL INFIXL
  | Fixity_implies_INFIXR INFIXR
  | Fixity_implies_INFIX INFIX
  deriving (Eq, Ord, Read, Show)

data Integer_opt =
    Integer_opt_implies
  | Integer_opt_implies_INTEGER INTEGER
  deriving (Eq, Ord, Read, Show)

data Ops =
    Ops_implies_MINUS MINUS
  | Ops_implies_op Op
  | Ops_implies_MINUS_COMMA_ops MINUS COMMA Ops
  | Ops_implies_op_COMMA_ops Op COMMA Ops
  deriving (Eq, Ord, Read, Show)

data Op =
    Op_implies_varop Varop
  | Op_implies_conop Conop
  deriving (Eq, Ord, Read, Show)

data Atype =
    Atype_implies_gtycon Gtycon
  | Atype_implies_tyvar Tyvar
  | Atype_implies_LPAREN_type_seq2_RPAREN LPAREN Type_seq2 RPAREN
  | Atype_implies_LBRACKET_type'_RBRACKET LBRACKET Type' RBRACKET
  | Atype_implies_LPAREN_type'_RPAREN LPAREN Type' RPAREN
  | Atype_implies_EXCL_atype EXCL Atype
  deriving (Eq, Ord, Read, Show)

data Gtycon =
    Gtycon_implies_con Con
  | Gtycon_implies_LPAREN_RPAREN LPAREN RPAREN
  | Gtycon_implies_LBRACKET_RBRACKET LBRACKET RBRACKET
  | Gtycon_implies_LPAREN_RARROW_RPAREN LPAREN RARROW RPAREN
  | Gtycon_implies_LPAREN_comma_list_RPAREN LPAREN Comma_list RPAREN
  deriving (Eq, Ord, Read, Show)

data Tyvar =
    Tyvar_implies_AS AS
  | Tyvar_implies_EXPORT EXPORT
  | Tyvar_implies_QVARID QVARID
  deriving (Eq, Ord, Read, Show)

data Type_seq2 =
    Type_seq2_implies_type'_COMMA_type' Type' COMMA Type'
  | Type_seq2_implies_type'_COMMA_type_seq2 Type' COMMA Type_seq2
  deriving (Eq, Ord, Read, Show)

data Comma_list =
    Comma_list_implies_COMMA COMMA
  | Comma_list_implies_COMMA_comma_list COMMA Comma_list
  deriving (Eq, Ord, Read, Show)

data Constrs =
    Constrs_implies_constr Constr
  | Constrs_implies_constr_PIPE_constrs Constr PIPE Constrs
  deriving (Eq, Ord, Read, Show)

data Constr =
    Constr_implies_btype Btype
  | Constr_implies_btype_conop_btype Btype Conop Btype
  | Constr_implies_con_LBRACE_RBRACE Con LBRACE RBRACE
  | Constr_implies_con_LBRACE_fielddecl_seq_RBRACE Con LBRACE Fielddecl_seq RBRACE
  deriving (Eq, Ord, Read, Show)

data Conop =
    Conop_implies_QCONSYM QCONSYM
  | Conop_implies_BACKQUOTE_QCONID_BACKQUOTE BACKQUOTE QCONID BACKQUOTE
  deriving (Eq, Ord, Read, Show)

data Fielddecl_seq =
    Fielddecl_seq_implies_fielddecl Fielddecl
  | Fielddecl_seq_implies_fielddecl_COMMA_fielddecl_seq Fielddecl COMMA Fielddecl_seq
  deriving (Eq, Ord, Read, Show)

data Fielddecl =
    Fielddecl_implies_vars_COLON_COLON_type' Vars COLON_COLON Type'
  deriving (Eq, Ord, Read, Show)

data Callconv =
    Callconv_implies_AS AS
  | Callconv_implies_EXPORT EXPORT
  | Callconv_implies_QVARID QVARID
  deriving (Eq, Ord, Read, Show)

data Impent =
    Impent_implies_STRING STRING
  deriving (Eq, Ord, Read, Show)

data Safety =
    Safety_implies_AS AS
  | Safety_implies_EXPORT EXPORT
  | Safety_implies_QVARID QVARID
  deriving (Eq, Ord, Read, Show)

data Expent =
    Expent_implies_STRING STRING
  deriving (Eq, Ord, Read, Show)

data Guards =
    Guards_implies_guard Guard
  | Guards_implies_guard_COMMA_guards Guard COMMA Guards
  deriving (Eq, Ord, Read, Show)

data Guard =
    Guard_implies_infixexp_LARROW_exp Infixexp LARROW Exp
  | Guard_implies_LET_decls LET Decls
  | Guard_implies_infixexp Infixexp
  deriving (Eq, Ord, Read, Show)

data Infixexp =
    Infixexp_implies_LAMBDA_pat_RARROW_exp LAMBDA Pat RARROW Exp
  | Infixexp_implies_LET_decls_IN_exp LET Decls IN Exp
  | Infixexp_implies_IF_exp_semicolon_opt_THEN_exp_semicolon_opt_ELSE_exp IF Exp Semicolon_opt THEN Exp Semicolon_opt ELSE Exp
  | Infixexp_implies_lexp_MINUS_exp Lexp MINUS Exp
  | Infixexp_implies_lexp_QVARSYM_exp Lexp QVARSYM Exp
  | Infixexp_implies_lexp_BACKQUOTE_AS_BACKQUOTE_exp Lexp BACKQUOTE AS BACKQUOTE Exp
  | Infixexp_implies_lexp_BACKQUOTE_EXPORT_BACKQUOTE_exp Lexp BACKQUOTE EXPORT BACKQUOTE Exp
  | Infixexp_implies_lexp_BACKQUOTE_QVARID_BACKQUOTE_exp Lexp BACKQUOTE QVARID BACKQUOTE Exp
  | Infixexp_implies_lexp_QCONSYM_exp Lexp QCONSYM Exp
  | Infixexp_implies_lexp_BACKQUOTE_QCONID_BACKQUOTE_exp Lexp BACKQUOTE QCONID BACKQUOTE Exp
  | Infixexp_implies_lexp_COLON_COLON_type' Lexp COLON_COLON Type'
  | Infixexp_implies_lexp_COLON_COLON_btype_DARROW_type' Lexp COLON_COLON Btype DARROW Type'
  | Infixexp_implies_lexp Lexp
  deriving (Eq, Ord, Read, Show)

data Semicolon_opt =
    Semicolon_opt_implies
  | Semicolon_opt_implies_SEMICOLON SEMICOLON
  deriving (Eq, Ord, Read, Show)

data Lexp =
    Lexp_implies_MINUS_fexp MINUS Fexp
  | Lexp_implies_fexp Fexp
  deriving (Eq, Ord, Read, Show)

data Fexp =
    Fexp_implies_aexp Aexp
  | Fexp_implies_fexp_aexp Fexp Aexp
  deriving (Eq, Ord, Read, Show)

data Aexp =
    Aexp_implies_var Var
  | Aexp_implies_INTEGER INTEGER
  | Aexp_implies_STRING STRING
  | Aexp_implies_LPAREN_exp_RPAREN LPAREN Exp RPAREN
  deriving (Eq, Ord, Read, Show)

data Apat =
    Apat_implies_var Var
  | Apat_implies_LPAREN_pat_RPAREN LPAREN Pat RPAREN
  deriving (Eq, Ord, Read, Show)

data Varop =
    Varop_implies_QVARSYM QVARSYM
  | Varop_implies_BACKQUOTE_AS_BACKQUOTE BACKQUOTE AS BACKQUOTE
  | Varop_implies_BACKQUOTE_EXPORT_BACKQUOTE BACKQUOTE EXPORT BACKQUOTE
  | Varop_implies_BACKQUOTE_QVARID_BACKQUOTE BACKQUOTE QVARID BACKQUOTE
  deriving (Eq, Ord, Read, Show)

data Tycls =
    Tycls_implies_QCONID QCONID
  deriving (Eq, Ord, Read, Show)

data StackValue =
    StackValue_EOF
  | StackValue_MODULE MODULE
  | StackValue_WHERE WHERE
  | StackValue_LBRACE LBRACE
  | StackValue_RBRACE RBRACE
  | StackValue_LPAREN LPAREN
  | StackValue_RPAREN RPAREN
  | StackValue_COMMA COMMA
  | StackValue_DOT_DOT DOT_DOT
  | StackValue_SEMICOLON SEMICOLON
  | StackValue_IMPORT IMPORT
  | StackValue_HIDING HIDING
  | StackValue_TYPE TYPE
  | StackValue_EQUAL EQUAL
  | StackValue_DATA DATA
  | StackValue_DERIVING DERIVING
  | StackValue_DARROW DARROW
  | StackValue_NEWTYPE NEWTYPE
  | StackValue_CLASS CLASS
  | StackValue_INSTANCE INSTANCE
  | StackValue_DEFAULT DEFAULT
  | StackValue_FOREIGN FOREIGN
  | StackValue_PIPE PIPE
  | StackValue_COLON_COLON COLON_COLON
  | StackValue_MINUS MINUS
  | StackValue_INFIXL INFIXL
  | StackValue_INFIXR INFIXR
  | StackValue_INFIX INFIX
  | StackValue_RARROW RARROW
  | StackValue_LBRACKET LBRACKET
  | StackValue_RBRACKET RBRACKET
  | StackValue_EXCL EXCL
  | StackValue_QCONID QCONID
  | StackValue_EXPORT EXPORT
  | StackValue_AS AS
  | StackValue_QVARID QVARID
  | StackValue_STRING STRING
  | StackValue_LARROW LARROW
  | StackValue_LET LET
  | StackValue_LAMBDA LAMBDA
  | StackValue_IN IN
  | StackValue_IF IF
  | StackValue_THEN THEN
  | StackValue_ELSE ELSE
  | StackValue_QVARSYM QVARSYM
  | StackValue_BACKQUOTE BACKQUOTE
  | StackValue_QCONSYM QCONSYM
  | StackValue_INTEGER INTEGER
  | StackValue_QUALIFIED QUALIFIED
  | StackValue_module' Module'
  | StackValue_modid Modid
  | StackValue_exports_opt Exports_opt
  | StackValue_body Body
  | StackValue_topdecls Topdecls
  | StackValue_exports Exports
  | StackValue_export_seq Export_seq
  | StackValue_export Export
  | StackValue_var Var
  | StackValue_con Con
  | StackValue_cname_seq Cname_seq
  | StackValue_import_seq Import_seq
  | StackValue_import' Import'
  | StackValue_cname Cname
  | StackValue_topdecl Topdecl
  | StackValue_qualified_opt Qualified_opt
  | StackValue_as_opt As_opt
  | StackValue_btype Btype
  | StackValue_type' Type'
  | StackValue_constrs_opt Constrs_opt
  | StackValue_dclass Dclass
  | StackValue_dclass_seq Dclass_seq
  | StackValue_newconstr Newconstr
  | StackValue_cdecls_opt Cdecls_opt
  | StackValue_idecls_opt Idecls_opt
  | StackValue_type_seq Type_seq
  | StackValue_fdecl Fdecl
  | StackValue_decl Decl
  | StackValue_decls Decls
  | StackValue_decl_seq Decl_seq
  | StackValue_gendecl Gendecl
  | StackValue_pat Pat
  | StackValue_exp Exp
  | StackValue_gdrhs Gdrhs
  | StackValue_cdecls Cdecls
  | StackValue_cdecl_seq Cdecl_seq
  | StackValue_cdecl Cdecl
  | StackValue_idecls Idecls
  | StackValue_idecl_seq Idecl_seq
  | StackValue_idecl Idecl
  | StackValue_vars Vars
  | StackValue_fixity Fixity
  | StackValue_integer_opt Integer_opt
  | StackValue_ops Ops
  | StackValue_op Op
  | StackValue_atype Atype
  | StackValue_gtycon Gtycon
  | StackValue_tyvar Tyvar
  | StackValue_type_seq2 Type_seq2
  | StackValue_comma_list Comma_list
  | StackValue_constrs Constrs
  | StackValue_constr Constr
  | StackValue_conop Conop
  | StackValue_fielddecl_seq Fielddecl_seq
  | StackValue_fielddecl Fielddecl
  | StackValue_callconv Callconv
  | StackValue_impent Impent
  | StackValue_safety Safety
  | StackValue_expent Expent
  | StackValue_guards Guards
  | StackValue_guard Guard
  | StackValue_infixexp Infixexp
  | StackValue_semicolon_opt Semicolon_opt
  | StackValue_lexp Lexp
  | StackValue_fexp Fexp
  | StackValue_aexp Aexp
  | StackValue_apat Apat
  | StackValue_varop Varop
  | StackValue_tycls Tycls

data SemanticActions m = SemanticActions
  { module'_implies_MODULE_modid_exports_opt_WHERE_body :: MODULE -> Modid -> Exports_opt -> WHERE -> Body -> m Module'
  , module'_implies_body :: Body -> m Module'
  , body_implies_LBRACE_topdecls_RBRACE :: LBRACE -> Topdecls -> RBRACE -> m Body
  , exports_opt_implies :: m Exports_opt
  , exports_opt_implies_exports :: Exports -> m Exports_opt
  , exports_implies_LPAREN_export_seq_RPAREN :: LPAREN -> Export_seq -> RPAREN -> m Exports
  , export_seq_implies :: m Export_seq
  , export_seq_implies_export :: Export -> m Export_seq
  , export_seq_implies_export_COMMA_export_seq :: Export -> COMMA -> Export_seq -> m Export_seq
  , export_implies_var :: Var -> m Export
  , export_implies_con :: Con -> m Export
  , export_implies_con_LPAREN_RPAREN :: Con -> LPAREN -> RPAREN -> m Export
  , export_implies_con_LPAREN_DOT_DOT_RPAREN :: Con -> LPAREN -> DOT_DOT -> RPAREN -> m Export
  , export_implies_con_LPAREN_cname_seq_RPAREN :: Con -> LPAREN -> Cname_seq -> RPAREN -> m Export
  , export_implies_MODULE_modid :: MODULE -> Modid -> m Export
  , import_seq_implies :: m Import_seq
  , import_seq_implies_import' :: Import' -> m Import_seq
  , import_seq_implies_import'_COMMA_import_seq :: Import' -> COMMA -> Import_seq -> m Import_seq
  , import'_implies_var :: Var -> m Import'
  , import'_implies_con :: Con -> m Import'
  , import'_implies_con_LPAREN_RPAREN :: Con -> LPAREN -> RPAREN -> m Import'
  , import'_implies_con_LPAREN_DOT_DOT_RPAREN :: Con -> LPAREN -> DOT_DOT -> RPAREN -> m Import'
  , import'_implies_con_LPAREN_cname_seq_RPAREN :: Con -> LPAREN -> Cname_seq -> RPAREN -> m Import'
  , cname_seq_implies_cname :: Cname -> m Cname_seq
  , cname_seq_implies_cname_COMMA_cname_seq :: Cname -> COMMA -> Cname_seq -> m Cname_seq
  , cname_implies_var :: Var -> m Cname
  , cname_implies_con :: Con -> m Cname
  , topdecls_implies_topdecl :: Topdecl -> m Topdecls
  , topdecls_implies_topdecl_SEMICOLON_topdecls :: Topdecl -> SEMICOLON -> Topdecls -> m Topdecls
  , topdecl_implies_IMPORT_qualified_opt_modid_as_opt :: IMPORT -> Qualified_opt -> Modid -> As_opt -> m Topdecl
  , topdecl_implies_IMPORT_qualified_opt_modid_as_opt_LPAREN_import_seq_RPAREN :: IMPORT -> Qualified_opt -> Modid -> As_opt -> LPAREN -> Import_seq -> RPAREN -> m Topdecl
  , topdecl_implies_IMPORT_qualified_opt_modid_as_opt_HIDING_LPAREN_import_seq_RPAREN :: IMPORT -> Qualified_opt -> Modid -> As_opt -> HIDING -> LPAREN -> Import_seq -> RPAREN -> m Topdecl
  , topdecl_implies_TYPE_btype_EQUAL_type' :: TYPE -> Btype -> EQUAL -> Type' -> m Topdecl
  , topdecl_implies_DATA_btype_constrs_opt :: DATA -> Btype -> Constrs_opt -> m Topdecl
  , topdecl_implies_DATA_btype_constrs_opt_DERIVING_dclass :: DATA -> Btype -> Constrs_opt -> DERIVING -> Dclass -> m Topdecl
  , topdecl_implies_DATA_btype_constrs_opt_DERIVING_LPAREN_RPAREN :: DATA -> Btype -> Constrs_opt -> DERIVING -> LPAREN -> RPAREN -> m Topdecl
  , topdecl_implies_DATA_btype_constrs_opt_DERIVING_LPAREN_dclass_seq_RPAREN :: DATA -> Btype -> Constrs_opt -> DERIVING -> LPAREN -> Dclass_seq -> RPAREN -> m Topdecl
  , topdecl_implies_DATA_btype_DARROW_btype_constrs_opt :: DATA -> Btype -> DARROW -> Btype -> Constrs_opt -> m Topdecl
  , topdecl_implies_DATA_btype_DARROW_btype_constrs_opt_DERIVING_dclass :: DATA -> Btype -> DARROW -> Btype -> Constrs_opt -> DERIVING -> Dclass -> m Topdecl
  , topdecl_implies_DATA_btype_DARROW_btype_constrs_opt_DERIVING_LPAREN_RPAREN :: DATA -> Btype -> DARROW -> Btype -> Constrs_opt -> DERIVING -> LPAREN -> RPAREN -> m Topdecl
  , topdecl_implies_DATA_btype_DARROW_btype_constrs_opt_DERIVING_LPAREN_dclass_seq_RPAREN :: DATA -> Btype -> DARROW -> Btype -> Constrs_opt -> DERIVING -> LPAREN -> Dclass_seq -> RPAREN -> m Topdecl
  , topdecl_implies_NEWTYPE_btype_newconstr :: NEWTYPE -> Btype -> Newconstr -> m Topdecl
  , topdecl_implies_NEWTYPE_btype_newconstr_DERIVING_dclass :: NEWTYPE -> Btype -> Newconstr -> DERIVING -> Dclass -> m Topdecl
  , topdecl_implies_NEWTYPE_btype_newconstr_DERIVING_LPAREN_RPAREN :: NEWTYPE -> Btype -> Newconstr -> DERIVING -> LPAREN -> RPAREN -> m Topdecl
  , topdecl_implies_NEWTYPE_btype_newconstr_DERIVING_LPAREN_dclass_seq_RPAREN :: NEWTYPE -> Btype -> Newconstr -> DERIVING -> LPAREN -> Dclass_seq -> RPAREN -> m Topdecl
  , topdecl_implies_NEWTYPE_btype_DARROW_btype_newconstr :: NEWTYPE -> Btype -> DARROW -> Btype -> Newconstr -> m Topdecl
  , topdecl_implies_NEWTYPE_btype_DARROW_btype_newconstr_DERIVING_dclass :: NEWTYPE -> Btype -> DARROW -> Btype -> Newconstr -> DERIVING -> Dclass -> m Topdecl
  , topdecl_implies_NEWTYPE_btype_DARROW_btype_newconstr_DERIVING_LPAREN_RPAREN :: NEWTYPE -> Btype -> DARROW -> Btype -> Newconstr -> DERIVING -> LPAREN -> RPAREN -> m Topdecl
  , topdecl_implies_NEWTYPE_btype_DARROW_btype_newconstr_DERIVING_LPAREN_dclass_seq_RPAREN :: NEWTYPE -> Btype -> DARROW -> Btype -> Newconstr -> DERIVING -> LPAREN -> Dclass_seq -> RPAREN -> m Topdecl
  , topdecl_implies_CLASS_btype_cdecls_opt :: CLASS -> Btype -> Cdecls_opt -> m Topdecl
  , topdecl_implies_CLASS_btype_DARROW_btype_cdecls_opt :: CLASS -> Btype -> DARROW -> Btype -> Cdecls_opt -> m Topdecl
  , topdecl_implies_INSTANCE_btype_idecls_opt :: INSTANCE -> Btype -> Idecls_opt -> m Topdecl
  , topdecl_implies_INSTANCE_btype_DARROW_btype_idecls_opt :: INSTANCE -> Btype -> DARROW -> Btype -> Idecls_opt -> m Topdecl
  , topdecl_implies_DEFAULT_LPAREN_RPAREN :: DEFAULT -> LPAREN -> RPAREN -> m Topdecl
  , topdecl_implies_DEFAULT_LPAREN_type_seq_RPAREN :: DEFAULT -> LPAREN -> Type_seq -> RPAREN -> m Topdecl
  , topdecl_implies_FOREIGN_fdecl :: FOREIGN -> Fdecl -> m Topdecl
  , topdecl_implies_decl :: Decl -> m Topdecl
  , decls_implies_LBRACE_decl_seq_RBRACE :: LBRACE -> Decl_seq -> RBRACE -> m Decls
  , decl_seq_implies_decl :: Decl -> m Decl_seq
  , decl_seq_implies_decl_SEMICOLON_decl_seq :: Decl -> SEMICOLON -> Decl_seq -> m Decl_seq
  , decl_implies_gendecl :: Gendecl -> m Decl
  , decl_implies_pat_EQUAL_exp :: Pat -> EQUAL -> Exp -> m Decl
  , decl_implies_pat_EQUAL_exp_WHERE_decls :: Pat -> EQUAL -> Exp -> WHERE -> Decls -> m Decl
  , decl_implies_pat_PIPE_gdrhs :: Pat -> PIPE -> Gdrhs -> m Decl
  , decl_implies_pat_PIPE_gdrhs_WHERE_decls :: Pat -> PIPE -> Gdrhs -> WHERE -> Decls -> m Decl
  , cdecls_opt_implies :: m Cdecls_opt
  , cdecls_opt_implies_WHERE_cdecls :: WHERE -> Cdecls -> m Cdecls_opt
  , cdecls_implies_LBRACE_cdecl_seq_RBRACE :: LBRACE -> Cdecl_seq -> RBRACE -> m Cdecls
  , cdecl_seq_implies_cdecl :: Cdecl -> m Cdecl_seq
  , cdecl_seq_implies_cdecl_SEMICOLON_cdecl_seq :: Cdecl -> SEMICOLON -> Cdecl_seq -> m Cdecl_seq
  , cdecl_implies_gendecl :: Gendecl -> m Cdecl
  , cdecl_implies_pat_EQUAL_exp :: Pat -> EQUAL -> Exp -> m Cdecl
  , cdecl_implies_pat_EQUAL_exp_WHERE_decls :: Pat -> EQUAL -> Exp -> WHERE -> Decls -> m Cdecl
  , cdecl_implies_pat_PIPE_gdrhs :: Pat -> PIPE -> Gdrhs -> m Cdecl
  , cdecl_implies_pat_PIPE_gdrhs_WHERE_decls :: Pat -> PIPE -> Gdrhs -> WHERE -> Decls -> m Cdecl
  , idecls_opt_implies :: m Idecls_opt
  , idecls_opt_implies_WHERE_idecls :: WHERE -> Idecls -> m Idecls_opt
  , idecls_implies_LBRACE_idecl_seq_RBRACE :: LBRACE -> Idecl_seq -> RBRACE -> m Idecls
  , idecl_seq_implies_idecl :: Idecl -> m Idecl_seq
  , idecl_seq_implies_idecl_SEMICOLON_idecl_seq :: Idecl -> SEMICOLON -> Idecl_seq -> m Idecl_seq
  , idecl_implies :: m Idecl
  , idecl_implies_pat_EQUAL_exp :: Pat -> EQUAL -> Exp -> m Idecl
  , idecl_implies_pat_EQUAL_exp_WHERE_decls :: Pat -> EQUAL -> Exp -> WHERE -> Decls -> m Idecl
  , idecl_implies_pat_PIPE_gdrhs :: Pat -> PIPE -> Gdrhs -> m Idecl
  , idecl_implies_pat_PIPE_gdrhs_WHERE_decls :: Pat -> PIPE -> Gdrhs -> WHERE -> Decls -> m Idecl
  , gendecl_implies :: m Gendecl
  , gendecl_implies_vars_COLON_COLON_type' :: Vars -> COLON_COLON -> Type' -> m Gendecl
  , gendecl_implies_vars_COLON_COLON_btype_DARROW_type' :: Vars -> COLON_COLON -> Btype -> DARROW -> Type' -> m Gendecl
  , gendecl_implies_fixity_integer_opt_ops :: Fixity -> Integer_opt -> Ops -> m Gendecl
  , ops_implies_MINUS :: MINUS -> m Ops
  , ops_implies_op :: Op -> m Ops
  , ops_implies_MINUS_COMMA_ops :: MINUS -> COMMA -> Ops -> m Ops
  , ops_implies_op_COMMA_ops :: Op -> COMMA -> Ops -> m Ops
  , vars_implies_var :: Var -> m Vars
  , vars_implies_var_COMMA_vars :: Var -> COMMA -> Vars -> m Vars
  , fixity_implies_INFIXL :: INFIXL -> m Fixity
  , fixity_implies_INFIXR :: INFIXR -> m Fixity
  , fixity_implies_INFIX :: INFIX -> m Fixity
  , type_seq_implies_type' :: Type' -> m Type_seq
  , type_seq_implies_type'_COMMA_type_seq :: Type' -> COMMA -> Type_seq -> m Type_seq
  , type'_implies_btype :: Btype -> m Type'
  , type'_implies_btype_RARROW_type' :: Btype -> RARROW -> Type' -> m Type'
  , btype_implies_atype :: Atype -> m Btype
  , btype_implies_btype_atype :: Btype -> Atype -> m Btype
  , atype_implies_gtycon :: Gtycon -> m Atype
  , atype_implies_tyvar :: Tyvar -> m Atype
  , atype_implies_LPAREN_type_seq2_RPAREN :: LPAREN -> Type_seq2 -> RPAREN -> m Atype
  , atype_implies_LBRACKET_type'_RBRACKET :: LBRACKET -> Type' -> RBRACKET -> m Atype
  , atype_implies_LPAREN_type'_RPAREN :: LPAREN -> Type' -> RPAREN -> m Atype
  , atype_implies_EXCL_atype :: EXCL -> Atype -> m Atype
  , type_seq2_implies_type'_COMMA_type' :: Type' -> COMMA -> Type' -> m Type_seq2
  , type_seq2_implies_type'_COMMA_type_seq2 :: Type' -> COMMA -> Type_seq2 -> m Type_seq2
  , gtycon_implies_con :: Con -> m Gtycon
  , gtycon_implies_LPAREN_RPAREN :: LPAREN -> RPAREN -> m Gtycon
  , gtycon_implies_LBRACKET_RBRACKET :: LBRACKET -> RBRACKET -> m Gtycon
  , gtycon_implies_LPAREN_RARROW_RPAREN :: LPAREN -> RARROW -> RPAREN -> m Gtycon
  , gtycon_implies_LPAREN_comma_list_RPAREN :: LPAREN -> Comma_list -> RPAREN -> m Gtycon
  , comma_list_implies_COMMA :: COMMA -> m Comma_list
  , comma_list_implies_COMMA_comma_list :: COMMA -> Comma_list -> m Comma_list
  , constrs_opt_implies :: m Constrs_opt
  , constrs_opt_implies_EQUAL_constrs :: EQUAL -> Constrs -> m Constrs_opt
  , constrs_implies_constr :: Constr -> m Constrs
  , constrs_implies_constr_PIPE_constrs :: Constr -> PIPE -> Constrs -> m Constrs
  , constr_implies_btype :: Btype -> m Constr
  , constr_implies_btype_conop_btype :: Btype -> Conop -> Btype -> m Constr
  , constr_implies_con_LBRACE_RBRACE :: Con -> LBRACE -> RBRACE -> m Constr
  , constr_implies_con_LBRACE_fielddecl_seq_RBRACE :: Con -> LBRACE -> Fielddecl_seq -> RBRACE -> m Constr
  , newconstr_implies_EQUAL_con_atype :: EQUAL -> Con -> Atype -> m Newconstr
  , newconstr_implies_EQUAL_con_LBRACE_var_COLON_COLON_type'_RBRACE :: EQUAL -> Con -> LBRACE -> Var -> COLON_COLON -> Type' -> RBRACE -> m Newconstr
  , fielddecl_seq_implies_fielddecl :: Fielddecl -> m Fielddecl_seq
  , fielddecl_seq_implies_fielddecl_COMMA_fielddecl_seq :: Fielddecl -> COMMA -> Fielddecl_seq -> m Fielddecl_seq
  , fielddecl_implies_vars_COLON_COLON_type' :: Vars -> COLON_COLON -> Type' -> m Fielddecl
  , dclass_seq_implies_dclass :: Dclass -> m Dclass_seq
  , dclass_seq_implies_dclass_COMMA_dclass_seq :: Dclass -> COMMA -> Dclass_seq -> m Dclass_seq
  , dclass_implies_QCONID :: QCONID -> m Dclass
  , fdecl_implies_IMPORT_callconv_impent_var_COLON_COLON_type' :: IMPORT -> Callconv -> Impent -> Var -> COLON_COLON -> Type' -> m Fdecl
  , fdecl_implies_IMPORT_callconv_safety_impent_var_COLON_COLON_type' :: IMPORT -> Callconv -> Safety -> Impent -> Var -> COLON_COLON -> Type' -> m Fdecl
  , fdecl_implies_EXPORT_callconv_expent_var_COLON_COLON_type' :: EXPORT -> Callconv -> Expent -> Var -> COLON_COLON -> Type' -> m Fdecl
  , callconv_implies_AS :: AS -> m Callconv
  , callconv_implies_EXPORT :: EXPORT -> m Callconv
  , callconv_implies_QVARID :: QVARID -> m Callconv
  , impent_implies_STRING :: STRING -> m Impent
  , expent_implies_STRING :: STRING -> m Expent
  , safety_implies_AS :: AS -> m Safety
  , safety_implies_EXPORT :: EXPORT -> m Safety
  , safety_implies_QVARID :: QVARID -> m Safety
  , gdrhs_implies_guards_EQUAL_exp :: Guards -> EQUAL -> Exp -> m Gdrhs
  , gdrhs_implies_guards_EQUAL_exp_PIPE_gdrhs :: Guards -> EQUAL -> Exp -> PIPE -> Gdrhs -> m Gdrhs
  , guards_implies_guard :: Guard -> m Guards
  , guards_implies_guard_COMMA_guards :: Guard -> COMMA -> Guards -> m Guards
  , guard_implies_infixexp_LARROW_exp :: Infixexp -> LARROW -> Exp -> m Guard
  , guard_implies_LET_decls :: LET -> Decls -> m Guard
  , guard_implies_infixexp :: Infixexp -> m Guard
  , exp_implies_infixexp :: Infixexp -> m Exp
  , infixexp_implies_LAMBDA_pat_RARROW_exp :: LAMBDA -> Pat -> RARROW -> Exp -> m Infixexp
  , infixexp_implies_LET_decls_IN_exp :: LET -> Decls -> IN -> Exp -> m Infixexp
  , infixexp_implies_IF_exp_semicolon_opt_THEN_exp_semicolon_opt_ELSE_exp :: IF -> Exp -> Semicolon_opt -> THEN -> Exp -> Semicolon_opt -> ELSE -> Exp -> m Infixexp
  , infixexp_implies_lexp_MINUS_exp :: Lexp -> MINUS -> Exp -> m Infixexp
  , infixexp_implies_lexp_QVARSYM_exp :: Lexp -> QVARSYM -> Exp -> m Infixexp
  , infixexp_implies_lexp_BACKQUOTE_AS_BACKQUOTE_exp :: Lexp -> BACKQUOTE -> AS -> BACKQUOTE -> Exp -> m Infixexp
  , infixexp_implies_lexp_BACKQUOTE_EXPORT_BACKQUOTE_exp :: Lexp -> BACKQUOTE -> EXPORT -> BACKQUOTE -> Exp -> m Infixexp
  , infixexp_implies_lexp_BACKQUOTE_QVARID_BACKQUOTE_exp :: Lexp -> BACKQUOTE -> QVARID -> BACKQUOTE -> Exp -> m Infixexp
  , infixexp_implies_lexp_QCONSYM_exp :: Lexp -> QCONSYM -> Exp -> m Infixexp
  , infixexp_implies_lexp_BACKQUOTE_QCONID_BACKQUOTE_exp :: Lexp -> BACKQUOTE -> QCONID -> BACKQUOTE -> Exp -> m Infixexp
  , infixexp_implies_lexp_COLON_COLON_type' :: Lexp -> COLON_COLON -> Type' -> m Infixexp
  , infixexp_implies_lexp_COLON_COLON_btype_DARROW_type' :: Lexp -> COLON_COLON -> Btype -> DARROW -> Type' -> m Infixexp
  , infixexp_implies_lexp :: Lexp -> m Infixexp
  , lexp_implies_MINUS_fexp :: MINUS -> Fexp -> m Lexp
  , lexp_implies_fexp :: Fexp -> m Lexp
  , fexp_implies_aexp :: Aexp -> m Fexp
  , fexp_implies_fexp_aexp :: Fexp -> Aexp -> m Fexp
  , aexp_implies_var :: Var -> m Aexp
  , aexp_implies_INTEGER :: INTEGER -> m Aexp
  , aexp_implies_STRING :: STRING -> m Aexp
  , aexp_implies_LPAREN_exp_RPAREN :: LPAREN -> Exp -> RPAREN -> m Aexp
  , pat_implies_apat :: Apat -> m Pat
  , pat_implies_pat_apat :: Pat -> Apat -> m Pat
  , pat_implies_pat_MINUS_apat :: Pat -> MINUS -> Apat -> m Pat
  , pat_implies_pat_op_apat :: Pat -> Op -> Apat -> m Pat
  , apat_implies_var :: Var -> m Apat
  , apat_implies_LPAREN_pat_RPAREN :: LPAREN -> Pat -> RPAREN -> m Apat
  , var_implies_AS :: AS -> m Var
  , var_implies_EXPORT :: EXPORT -> m Var
  , var_implies_QVARID :: QVARID -> m Var
  , var_implies_LPAREN_MINUS_RPAREN :: LPAREN -> MINUS -> RPAREN -> m Var
  , var_implies_LPAREN_QVARSYM_RPAREN :: LPAREN -> QVARSYM -> RPAREN -> m Var
  , con_implies_QCONID :: QCONID -> m Con
  , con_implies_LPAREN_QCONSYM_RPAREN :: LPAREN -> QCONSYM -> RPAREN -> m Con
  , varop_implies_QVARSYM :: QVARSYM -> m Varop
  , varop_implies_BACKQUOTE_AS_BACKQUOTE :: BACKQUOTE -> AS -> BACKQUOTE -> m Varop
  , varop_implies_BACKQUOTE_EXPORT_BACKQUOTE :: BACKQUOTE -> EXPORT -> BACKQUOTE -> m Varop
  , varop_implies_BACKQUOTE_QVARID_BACKQUOTE :: BACKQUOTE -> QVARID -> BACKQUOTE -> m Varop
  , conop_implies_QCONSYM :: QCONSYM -> m Conop
  , conop_implies_BACKQUOTE_QCONID_BACKQUOTE :: BACKQUOTE -> QCONID -> BACKQUOTE -> m Conop
  , op_implies_varop :: Varop -> m Op
  , op_implies_conop :: Conop -> m Op
  , as_opt_implies :: m As_opt
  , as_opt_implies_AS_modid :: AS -> Modid -> m As_opt
  , qualified_opt_implies :: m Qualified_opt
  , qualified_opt_implies_QUALIFIED :: QUALIFIED -> m Qualified_opt
  , tyvar_implies_AS :: AS -> m Tyvar
  , tyvar_implies_EXPORT :: EXPORT -> m Tyvar
  , tyvar_implies_QVARID :: QVARID -> m Tyvar
  , tycls_implies_QCONID :: QCONID -> m Tycls
  , modid_implies_QCONID :: QCONID -> m Modid
  , integer_opt_implies :: m Integer_opt
  , integer_opt_implies_INTEGER :: INTEGER -> m Integer_opt
  , semicolon_opt_implies :: m Semicolon_opt
  , semicolon_opt_implies_SEMICOLON :: SEMICOLON -> m Semicolon_opt }

dfaActionTransition :: ActionState -> ActionSymbol -> Maybe Action
dfaActionTransition q s =
  case (q, s) of
    (0, Token (MODULE _)) -> Just (Shift 2)
    (0, Token (LBRACE _)) -> Just (Shift 13)
    (1, EOF) -> Just (Accept)
    (2, Token (QCONID _)) -> Just (Shift 11)
    (3, Token (LBRACE _)) -> Just (Shift 13)
    (4, Token (WHERE _)) -> Just (Reduce 0 3)
    (4, Token (LPAREN _)) -> Just (Shift 19)
    (5, Token (WHERE _)) -> Just (Shift 3)
    (6, EOF) -> Just (Reduce 1 1)
    (7, EOF) -> Just (Reduce 5 0)
    (8, Token (QCONID _)) -> Just (Shift 11)
    (9, Token (QCONID _)) -> Just (Shift 11)
    (10, Token (QCONID _)) -> Just (Shift 11)
    (11, Token (MODULE _)) -> Just (Reduce 1 204)
    (11, Token (WHERE _)) -> Just (Reduce 1 204)
    (11, Token (RBRACE _)) -> Just (Reduce 1 204)
    (11, Token (LPAREN _)) -> Just (Reduce 1 204)
    (11, Token (RPAREN _)) -> Just (Reduce 1 204)
    (11, Token (COMMA _)) -> Just (Reduce 1 204)
    (11, Token (SEMICOLON _)) -> Just (Reduce 1 204)
    (11, Token (HIDING _)) -> Just (Reduce 1 204)
    (11, Token (MINUS _)) -> Just (Reduce 1 204)
    (11, Token (QCONID _)) -> Just (Reduce 1 204)
    (11, Token (EXPORT _)) -> Just (Reduce 1 204)
    (11, Token (AS _)) -> Just (Reduce 1 204)
    (11, Token (QVARID _)) -> Just (Reduce 1 204)
    (11, Token (QVARSYM _)) -> Just (Reduce 1 204)
    (11, Token (QCONSYM _)) -> Just (Reduce 1 204)
    (12, Token (WHERE _)) -> Just (Reduce 1 4)
    (13, Token (RBRACE _)) -> Just (Reduce 0 85)
    (13, Token (LPAREN _)) -> Just (Shift 63)
    (13, Token (SEMICOLON _)) -> Just (Reduce 0 85)
    (13, Token (IMPORT _)) -> Just (Shift 175)
    (13, Token (TYPE _)) -> Just (Shift 133)
    (13, Token (DATA _)) -> Just (Shift 111)
    (13, Token (NEWTYPE _)) -> Just (Shift 131)
    (13, Token (CLASS _)) -> Just (Shift 98)
    (13, Token (INSTANCE _)) -> Just (Shift 100)
    (13, Token (DEFAULT _)) -> Just (Shift 181)
    (13, Token (FOREIGN _)) -> Just (Shift 182)
    (13, Token (INFIXL _)) -> Just (Shift 289)
    (13, Token (INFIXR _)) -> Just (Shift 290)
    (13, Token (INFIX _)) -> Just (Shift 291)
    (13, Token (EXPORT _)) -> Just (Shift 93)
    (13, Token (AS _)) -> Just (Shift 94)
    (13, Token (QVARID _)) -> Just (Shift 95)
    (14, EOF) -> Just (Reduce 3 2)
    (15, Token (RBRACE _)) -> Just (Shift 14)
    (16, Token (RBRACE _)) -> Just (Reduce 0 85)
    (16, Token (LPAREN _)) -> Just (Shift 63)
    (16, Token (SEMICOLON _)) -> Just (Reduce 0 85)
    (16, Token (IMPORT _)) -> Just (Shift 175)
    (16, Token (TYPE _)) -> Just (Shift 133)
    (16, Token (DATA _)) -> Just (Shift 111)
    (16, Token (NEWTYPE _)) -> Just (Shift 131)
    (16, Token (CLASS _)) -> Just (Shift 98)
    (16, Token (INSTANCE _)) -> Just (Shift 100)
    (16, Token (DEFAULT _)) -> Just (Shift 181)
    (16, Token (FOREIGN _)) -> Just (Shift 182)
    (16, Token (INFIXL _)) -> Just (Shift 289)
    (16, Token (INFIXR _)) -> Just (Shift 290)
    (16, Token (INFIX _)) -> Just (Shift 291)
    (16, Token (EXPORT _)) -> Just (Shift 93)
    (16, Token (AS _)) -> Just (Shift 94)
    (16, Token (QVARID _)) -> Just (Shift 95)
    (17, Token (RBRACE _)) -> Just (Reduce 3 28)
    (18, Token (RBRACE _)) -> Just (Reduce 1 27)
    (18, Token (SEMICOLON _)) -> Just (Shift 16)
    (19, Token (MODULE _)) -> Just (Shift 10)
    (19, Token (LPAREN _)) -> Just (Shift 88)
    (19, Token (RPAREN _)) -> Just (Reduce 0 6)
    (19, Token (QCONID _)) -> Just (Shift 144)
    (19, Token (EXPORT _)) -> Just (Shift 93)
    (19, Token (AS _)) -> Just (Shift 94)
    (19, Token (QVARID _)) -> Just (Shift 95)
    (20, Token (WHERE _)) -> Just (Reduce 3 5)
    (21, Token (RPAREN _)) -> Just (Shift 20)
    (22, Token (MODULE _)) -> Just (Shift 10)
    (22, Token (LPAREN _)) -> Just (Shift 88)
    (22, Token (RPAREN _)) -> Just (Reduce 0 6)
    (22, Token (QCONID _)) -> Just (Shift 144)
    (22, Token (EXPORT _)) -> Just (Shift 93)
    (22, Token (AS _)) -> Just (Shift 94)
    (22, Token (QVARID _)) -> Just (Shift 95)
    (23, Token (RPAREN _)) -> Just (Reduce 3 8)
    (24, Token (RPAREN _)) -> Just (Reduce 1 7)
    (24, Token (COMMA _)) -> Just (Shift 22)
    (25, Token (LPAREN _)) -> Just (Shift 88)
    (25, Token (RPAREN _)) -> Just (Shift 26)
    (25, Token (DOT_DOT _)) -> Just (Shift 29)
    (25, Token (QCONID _)) -> Just (Shift 144)
    (25, Token (EXPORT _)) -> Just (Shift 93)
    (25, Token (AS _)) -> Just (Shift 94)
    (25, Token (QVARID _)) -> Just (Shift 95)
    (26, Token (RPAREN _)) -> Just (Reduce 3 11)
    (26, Token (COMMA _)) -> Just (Reduce 3 11)
    (27, Token (RPAREN _)) -> Just (Reduce 4 12)
    (27, Token (COMMA _)) -> Just (Reduce 4 12)
    (28, Token (RPAREN _)) -> Just (Reduce 4 13)
    (28, Token (COMMA _)) -> Just (Reduce 4 13)
    (29, Token (RPAREN _)) -> Just (Shift 27)
    (30, Token (RPAREN _)) -> Just (Reduce 2 14)
    (30, Token (COMMA _)) -> Just (Reduce 2 14)
    (31, Token (RPAREN _)) -> Just (Reduce 1 9)
    (31, Token (COMMA _)) -> Just (Reduce 1 9)
    (32, Token (LPAREN _)) -> Just (Shift 25)
    (32, Token (RPAREN _)) -> Just (Reduce 1 10)
    (32, Token (COMMA _)) -> Just (Reduce 1 10)
    (33, Token (RPAREN _)) -> Just (Shift 28)
    (34, Token (LPAREN _)) -> Just (Shift 51)
    (34, Token (MINUS _)) -> Just (Shift 44)
    (34, Token (EXPORT _)) -> Just (Shift 93)
    (34, Token (AS _)) -> Just (Shift 94)
    (34, Token (QVARID _)) -> Just (Shift 95)
    (34, Token (STRING _)) -> Just (Shift 379)
    (34, Token (LET _)) -> Just (Shift 250)
    (34, Token (LAMBDA _)) -> Just (Shift 74)
    (34, Token (IF _)) -> Just (Shift 58)
    (34, Token (INTEGER _)) -> Just (Shift 380)
    (35, Token (LPAREN _)) -> Just (Shift 51)
    (35, Token (MINUS _)) -> Just (Shift 44)
    (35, Token (EXPORT _)) -> Just (Shift 93)
    (35, Token (AS _)) -> Just (Shift 94)
    (35, Token (QVARID _)) -> Just (Shift 95)
    (35, Token (STRING _)) -> Just (Shift 379)
    (35, Token (LET _)) -> Just (Shift 250)
    (35, Token (LAMBDA _)) -> Just (Shift 74)
    (35, Token (IF _)) -> Just (Shift 58)
    (35, Token (INTEGER _)) -> Just (Shift 380)
    (36, Token (LPAREN _)) -> Just (Shift 51)
    (36, Token (MINUS _)) -> Just (Shift 44)
    (36, Token (EXPORT _)) -> Just (Shift 93)
    (36, Token (AS _)) -> Just (Shift 94)
    (36, Token (QVARID _)) -> Just (Shift 95)
    (36, Token (STRING _)) -> Just (Shift 379)
    (36, Token (LET _)) -> Just (Shift 250)
    (36, Token (LAMBDA _)) -> Just (Shift 74)
    (36, Token (IF _)) -> Just (Shift 58)
    (36, Token (INTEGER _)) -> Just (Shift 380)
    (37, Token (LPAREN _)) -> Just (Shift 51)
    (37, Token (MINUS _)) -> Just (Shift 44)
    (37, Token (EXPORT _)) -> Just (Shift 93)
    (37, Token (AS _)) -> Just (Shift 94)
    (37, Token (QVARID _)) -> Just (Shift 95)
    (37, Token (STRING _)) -> Just (Shift 379)
    (37, Token (LET _)) -> Just (Shift 250)
    (37, Token (LAMBDA _)) -> Just (Shift 74)
    (37, Token (IF _)) -> Just (Shift 58)
    (37, Token (INTEGER _)) -> Just (Shift 380)
    (38, Token (LPAREN _)) -> Just (Shift 51)
    (38, Token (MINUS _)) -> Just (Shift 44)
    (38, Token (EXPORT _)) -> Just (Shift 93)
    (38, Token (AS _)) -> Just (Shift 94)
    (38, Token (QVARID _)) -> Just (Shift 95)
    (38, Token (STRING _)) -> Just (Shift 379)
    (38, Token (LET _)) -> Just (Shift 250)
    (38, Token (LAMBDA _)) -> Just (Shift 74)
    (38, Token (IF _)) -> Just (Shift 58)
    (38, Token (INTEGER _)) -> Just (Shift 380)
    (39, Token (LPAREN _)) -> Just (Shift 51)
    (39, Token (MINUS _)) -> Just (Shift 44)
    (39, Token (EXPORT _)) -> Just (Shift 93)
    (39, Token (AS _)) -> Just (Shift 94)
    (39, Token (QVARID _)) -> Just (Shift 95)
    (39, Token (STRING _)) -> Just (Shift 379)
    (39, Token (LET _)) -> Just (Shift 250)
    (39, Token (LAMBDA _)) -> Just (Shift 74)
    (39, Token (IF _)) -> Just (Shift 58)
    (39, Token (INTEGER _)) -> Just (Shift 380)
    (40, Token (LPAREN _)) -> Just (Shift 51)
    (40, Token (MINUS _)) -> Just (Shift 44)
    (40, Token (EXPORT _)) -> Just (Shift 93)
    (40, Token (AS _)) -> Just (Shift 94)
    (40, Token (QVARID _)) -> Just (Shift 95)
    (40, Token (STRING _)) -> Just (Shift 379)
    (40, Token (LET _)) -> Just (Shift 250)
    (40, Token (LAMBDA _)) -> Just (Shift 74)
    (40, Token (IF _)) -> Just (Shift 58)
    (40, Token (INTEGER _)) -> Just (Shift 380)
    (41, Token (LPAREN _)) -> Just (Shift 51)
    (41, Token (MINUS _)) -> Just (Shift 44)
    (41, Token (EXPORT _)) -> Just (Shift 93)
    (41, Token (AS _)) -> Just (Shift 94)
    (41, Token (QVARID _)) -> Just (Shift 95)
    (41, Token (STRING _)) -> Just (Shift 379)
    (41, Token (LET _)) -> Just (Shift 250)
    (41, Token (LAMBDA _)) -> Just (Shift 74)
    (41, Token (IF _)) -> Just (Shift 58)
    (41, Token (INTEGER _)) -> Just (Shift 380)
    (42, Token (LPAREN _)) -> Just (Shift 51)
    (42, Token (MINUS _)) -> Just (Shift 44)
    (42, Token (EXPORT _)) -> Just (Shift 93)
    (42, Token (AS _)) -> Just (Shift 94)
    (42, Token (QVARID _)) -> Just (Shift 95)
    (42, Token (STRING _)) -> Just (Shift 379)
    (42, Token (LET _)) -> Just (Shift 250)
    (42, Token (LAMBDA _)) -> Just (Shift 74)
    (42, Token (IF _)) -> Just (Shift 58)
    (42, Token (INTEGER _)) -> Just (Shift 380)
    (43, Token (LPAREN _)) -> Just (Shift 51)
    (43, Token (MINUS _)) -> Just (Shift 44)
    (43, Token (EXPORT _)) -> Just (Shift 93)
    (43, Token (AS _)) -> Just (Shift 94)
    (43, Token (QVARID _)) -> Just (Shift 95)
    (43, Token (STRING _)) -> Just (Shift 379)
    (43, Token (LET _)) -> Just (Shift 250)
    (43, Token (LAMBDA _)) -> Just (Shift 74)
    (43, Token (IF _)) -> Just (Shift 58)
    (43, Token (INTEGER _)) -> Just (Shift 380)
    (44, Token (LPAREN _)) -> Just (Shift 51)
    (44, Token (EXPORT _)) -> Just (Shift 93)
    (44, Token (AS _)) -> Just (Shift 94)
    (44, Token (QVARID _)) -> Just (Shift 95)
    (44, Token (STRING _)) -> Just (Shift 379)
    (44, Token (INTEGER _)) -> Just (Shift 380)
    (45, Token (WHERE _)) -> Just (Reduce 1 168)
    (45, Token (RBRACE _)) -> Just (Reduce 1 168)
    (45, Token (LPAREN _)) -> Just (Shift 51)
    (45, Token (RPAREN _)) -> Just (Reduce 1 168)
    (45, Token (COMMA _)) -> Just (Reduce 1 168)
    (45, Token (SEMICOLON _)) -> Just (Reduce 1 168)
    (45, Token (EQUAL _)) -> Just (Reduce 1 168)
    (45, Token (PIPE _)) -> Just (Reduce 1 168)
    (45, Token (COLON_COLON _)) -> Just (Reduce 1 168)
    (45, Token (MINUS _)) -> Just (Reduce 1 168)
    (45, Token (EXPORT _)) -> Just (Shift 93)
    (45, Token (AS _)) -> Just (Shift 94)
    (45, Token (QVARID _)) -> Just (Shift 95)
    (45, Token (STRING _)) -> Just (Shift 379)
    (45, Token (LARROW _)) -> Just (Reduce 1 168)
    (45, Token (THEN _)) -> Just (Reduce 1 168)
    (45, Token (ELSE _)) -> Just (Reduce 1 168)
    (45, Token (QVARSYM _)) -> Just (Reduce 1 168)
    (45, Token (BACKQUOTE _)) -> Just (Reduce 1 168)
    (45, Token (QCONSYM _)) -> Just (Reduce 1 168)
    (45, Token (INTEGER _)) -> Just (Shift 380)
    (46, Token (WHERE _)) -> Just (Reduce 2 167)
    (46, Token (RBRACE _)) -> Just (Reduce 2 167)
    (46, Token (LPAREN _)) -> Just (Shift 51)
    (46, Token (RPAREN _)) -> Just (Reduce 2 167)
    (46, Token (COMMA _)) -> Just (Reduce 2 167)
    (46, Token (SEMICOLON _)) -> Just (Reduce 2 167)
    (46, Token (EQUAL _)) -> Just (Reduce 2 167)
    (46, Token (PIPE _)) -> Just (Reduce 2 167)
    (46, Token (COLON_COLON _)) -> Just (Reduce 2 167)
    (46, Token (MINUS _)) -> Just (Reduce 2 167)
    (46, Token (EXPORT _)) -> Just (Shift 93)
    (46, Token (AS _)) -> Just (Shift 94)
    (46, Token (QVARID _)) -> Just (Shift 95)
    (46, Token (STRING _)) -> Just (Shift 379)
    (46, Token (LARROW _)) -> Just (Reduce 2 167)
    (46, Token (THEN _)) -> Just (Reduce 2 167)
    (46, Token (ELSE _)) -> Just (Reduce 2 167)
    (46, Token (QVARSYM _)) -> Just (Reduce 2 167)
    (46, Token (BACKQUOTE _)) -> Just (Reduce 2 167)
    (46, Token (QCONSYM _)) -> Just (Reduce 2 167)
    (46, Token (INTEGER _)) -> Just (Shift 380)
    (47, Token (LPAREN _)) -> Just (Shift 51)
    (47, Token (MINUS _)) -> Just (Shift 44)
    (47, Token (EXPORT _)) -> Just (Shift 93)
    (47, Token (AS _)) -> Just (Shift 94)
    (47, Token (QVARID _)) -> Just (Shift 95)
    (47, Token (STRING _)) -> Just (Shift 379)
    (47, Token (LET _)) -> Just (Shift 250)
    (47, Token (LAMBDA _)) -> Just (Shift 74)
    (47, Token (IF _)) -> Just (Shift 58)
    (47, Token (INTEGER _)) -> Just (Shift 380)
    (48, Token (LPAREN _)) -> Just (Shift 51)
    (48, Token (MINUS _)) -> Just (Shift 44)
    (48, Token (EXPORT _)) -> Just (Shift 93)
    (48, Token (AS _)) -> Just (Shift 94)
    (48, Token (QVARID _)) -> Just (Shift 95)
    (48, Token (STRING _)) -> Just (Shift 379)
    (48, Token (LET _)) -> Just (Shift 250)
    (48, Token (LAMBDA _)) -> Just (Shift 74)
    (48, Token (IF _)) -> Just (Shift 58)
    (48, Token (INTEGER _)) -> Just (Shift 380)
    (49, Token (LPAREN _)) -> Just (Shift 51)
    (49, Token (MINUS _)) -> Just (Shift 44)
    (49, Token (EXPORT _)) -> Just (Shift 93)
    (49, Token (AS _)) -> Just (Shift 94)
    (49, Token (QVARID _)) -> Just (Shift 95)
    (49, Token (STRING _)) -> Just (Shift 379)
    (49, Token (LET _)) -> Just (Shift 250)
    (49, Token (LAMBDA _)) -> Just (Shift 74)
    (49, Token (IF _)) -> Just (Shift 58)
    (49, Token (INTEGER _)) -> Just (Shift 380)
    (50, Token (LPAREN _)) -> Just (Shift 51)
    (50, Token (MINUS _)) -> Just (Shift 44)
    (50, Token (EXPORT _)) -> Just (Shift 93)
    (50, Token (AS _)) -> Just (Shift 94)
    (50, Token (QVARID _)) -> Just (Shift 95)
    (50, Token (STRING _)) -> Just (Shift 379)
    (50, Token (LET _)) -> Just (Shift 250)
    (50, Token (LAMBDA _)) -> Just (Shift 74)
    (50, Token (IF _)) -> Just (Shift 58)
    (50, Token (INTEGER _)) -> Just (Shift 380)
    (51, Token (LPAREN _)) -> Just (Shift 51)
    (51, Token (MINUS _)) -> Just (Shift 52)
    (51, Token (EXPORT _)) -> Just (Shift 93)
    (51, Token (AS _)) -> Just (Shift 94)
    (51, Token (QVARID _)) -> Just (Shift 95)
    (51, Token (STRING _)) -> Just (Shift 379)
    (51, Token (LET _)) -> Just (Shift 250)
    (51, Token (LAMBDA _)) -> Just (Shift 74)
    (51, Token (IF _)) -> Just (Shift 58)
    (51, Token (QVARSYM _)) -> Just (Shift 96)
    (51, Token (INTEGER _)) -> Just (Shift 380)
    (52, Token (LPAREN _)) -> Just (Shift 51)
    (52, Token (RPAREN _)) -> Just (Shift 90)
    (52, Token (EXPORT _)) -> Just (Shift 93)
    (52, Token (AS _)) -> Just (Shift 94)
    (52, Token (QVARID _)) -> Just (Shift 95)
    (52, Token (STRING _)) -> Just (Shift 379)
    (52, Token (INTEGER _)) -> Just (Shift 380)
    (53, Token (LPAREN _)) -> Just (Shift 51)
    (53, Token (MINUS _)) -> Just (Shift 44)
    (53, Token (EXPORT _)) -> Just (Shift 93)
    (53, Token (AS _)) -> Just (Shift 94)
    (53, Token (QVARID _)) -> Just (Shift 95)
    (53, Token (STRING _)) -> Just (Shift 379)
    (53, Token (LET _)) -> Just (Shift 249)
    (53, Token (LAMBDA _)) -> Just (Shift 74)
    (53, Token (IF _)) -> Just (Shift 58)
    (53, Token (INTEGER _)) -> Just (Shift 380)
    (54, Token (LPAREN _)) -> Just (Shift 51)
    (54, Token (MINUS _)) -> Just (Shift 44)
    (54, Token (EXPORT _)) -> Just (Shift 93)
    (54, Token (AS _)) -> Just (Shift 94)
    (54, Token (QVARID _)) -> Just (Shift 95)
    (54, Token (STRING _)) -> Just (Shift 379)
    (54, Token (LET _)) -> Just (Shift 249)
    (54, Token (LAMBDA _)) -> Just (Shift 74)
    (54, Token (IF _)) -> Just (Shift 58)
    (54, Token (INTEGER _)) -> Just (Shift 380)
    (55, Token (LPAREN _)) -> Just (Shift 51)
    (55, Token (MINUS _)) -> Just (Shift 44)
    (55, Token (EXPORT _)) -> Just (Shift 93)
    (55, Token (AS _)) -> Just (Shift 94)
    (55, Token (QVARID _)) -> Just (Shift 95)
    (55, Token (STRING _)) -> Just (Shift 379)
    (55, Token (LET _)) -> Just (Shift 249)
    (55, Token (LAMBDA _)) -> Just (Shift 74)
    (55, Token (IF _)) -> Just (Shift 58)
    (55, Token (INTEGER _)) -> Just (Shift 380)
    (56, Token (LPAREN _)) -> Just (Shift 51)
    (56, Token (MINUS _)) -> Just (Shift 44)
    (56, Token (EXPORT _)) -> Just (Shift 93)
    (56, Token (AS _)) -> Just (Shift 94)
    (56, Token (QVARID _)) -> Just (Shift 95)
    (56, Token (STRING _)) -> Just (Shift 379)
    (56, Token (LET _)) -> Just (Shift 249)
    (56, Token (LAMBDA _)) -> Just (Shift 74)
    (56, Token (IF _)) -> Just (Shift 58)
    (56, Token (INTEGER _)) -> Just (Shift 380)
    (57, Token (LPAREN _)) -> Just (Shift 51)
    (57, Token (MINUS _)) -> Just (Shift 44)
    (57, Token (EXPORT _)) -> Just (Shift 93)
    (57, Token (AS _)) -> Just (Shift 94)
    (57, Token (QVARID _)) -> Just (Shift 95)
    (57, Token (STRING _)) -> Just (Shift 379)
    (57, Token (LET _)) -> Just (Shift 249)
    (57, Token (LAMBDA _)) -> Just (Shift 74)
    (57, Token (IF _)) -> Just (Shift 58)
    (57, Token (INTEGER _)) -> Just (Shift 380)
    (58, Token (LPAREN _)) -> Just (Shift 51)
    (58, Token (MINUS _)) -> Just (Shift 44)
    (58, Token (EXPORT _)) -> Just (Shift 93)
    (58, Token (AS _)) -> Just (Shift 94)
    (58, Token (QVARID _)) -> Just (Shift 95)
    (58, Token (STRING _)) -> Just (Shift 379)
    (58, Token (LET _)) -> Just (Shift 250)
    (58, Token (LAMBDA _)) -> Just (Shift 74)
    (58, Token (IF _)) -> Just (Shift 58)
    (58, Token (INTEGER _)) -> Just (Shift 380)
    (59, Token (LPAREN _)) -> Just (Shift 51)
    (59, Token (MINUS _)) -> Just (Shift 44)
    (59, Token (EXPORT _)) -> Just (Shift 93)
    (59, Token (AS _)) -> Just (Shift 94)
    (59, Token (QVARID _)) -> Just (Shift 95)
    (59, Token (STRING _)) -> Just (Shift 379)
    (59, Token (LET _)) -> Just (Shift 250)
    (59, Token (LAMBDA _)) -> Just (Shift 74)
    (59, Token (IF _)) -> Just (Shift 58)
    (59, Token (INTEGER _)) -> Just (Shift 380)
    (60, Token (LPAREN _)) -> Just (Shift 51)
    (60, Token (MINUS _)) -> Just (Shift 44)
    (60, Token (EXPORT _)) -> Just (Shift 93)
    (60, Token (AS _)) -> Just (Shift 94)
    (60, Token (QVARID _)) -> Just (Shift 95)
    (60, Token (STRING _)) -> Just (Shift 379)
    (60, Token (LET _)) -> Just (Shift 250)
    (60, Token (LAMBDA _)) -> Just (Shift 74)
    (60, Token (IF _)) -> Just (Shift 58)
    (60, Token (INTEGER _)) -> Just (Shift 380)
    (61, Token (LPAREN _)) -> Just (Shift 63)
    (61, Token (EXPORT _)) -> Just (Shift 93)
    (61, Token (AS _)) -> Just (Shift 94)
    (61, Token (QVARID _)) -> Just (Shift 95)
    (62, Token (LPAREN _)) -> Just (Shift 63)
    (62, Token (EXPORT _)) -> Just (Shift 93)
    (62, Token (AS _)) -> Just (Shift 94)
    (62, Token (QVARID _)) -> Just (Shift 95)
    (63, Token (LPAREN _)) -> Just (Shift 63)
    (63, Token (MINUS _)) -> Just (Shift 92)
    (63, Token (EXPORT _)) -> Just (Shift 93)
    (63, Token (AS _)) -> Just (Shift 94)
    (63, Token (QVARID _)) -> Just (Shift 95)
    (63, Token (QVARSYM _)) -> Just (Shift 96)
    (64, Token (LPAREN _)) -> Just (Shift 63)
    (64, Token (RPAREN _)) -> Just (Shift 383)
    (64, Token (MINUS _)) -> Just (Shift 61)
    (64, Token (EXPORT _)) -> Just (Shift 93)
    (64, Token (AS _)) -> Just (Shift 94)
    (64, Token (QVARID _)) -> Just (Shift 95)
    (64, Token (QVARSYM _)) -> Just (Shift 388)
    (64, Token (BACKQUOTE _)) -> Just (Shift 331)
    (64, Token (QCONSYM _)) -> Just (Shift 334)
    (65, Token (RBRACE _)) -> Just (Reduce 0 85)
    (65, Token (LPAREN _)) -> Just (Shift 63)
    (65, Token (SEMICOLON _)) -> Just (Reduce 0 85)
    (65, Token (INFIXL _)) -> Just (Shift 289)
    (65, Token (INFIXR _)) -> Just (Shift 290)
    (65, Token (INFIX _)) -> Just (Shift 291)
    (65, Token (EXPORT _)) -> Just (Shift 93)
    (65, Token (AS _)) -> Just (Shift 94)
    (65, Token (QVARID _)) -> Just (Shift 95)
    (66, Token (RBRACE _)) -> Just (Reduce 0 85)
    (66, Token (LPAREN _)) -> Just (Shift 63)
    (66, Token (SEMICOLON _)) -> Just (Reduce 0 85)
    (66, Token (INFIXL _)) -> Just (Shift 289)
    (66, Token (INFIXR _)) -> Just (Shift 290)
    (66, Token (INFIX _)) -> Just (Shift 291)
    (66, Token (EXPORT _)) -> Just (Shift 93)
    (66, Token (AS _)) -> Just (Shift 94)
    (66, Token (QVARID _)) -> Just (Shift 95)
    (67, Token (RBRACE _)) -> Just (Reduce 0 85)
    (67, Token (LPAREN _)) -> Just (Shift 63)
    (67, Token (SEMICOLON _)) -> Just (Reduce 0 85)
    (67, Token (INFIXL _)) -> Just (Shift 289)
    (67, Token (INFIXR _)) -> Just (Shift 290)
    (67, Token (INFIX _)) -> Just (Shift 291)
    (67, Token (EXPORT _)) -> Just (Shift 93)
    (67, Token (AS _)) -> Just (Shift 94)
    (67, Token (QVARID _)) -> Just (Shift 95)
    (68, Token (RBRACE _)) -> Just (Reduce 0 85)
    (68, Token (LPAREN _)) -> Just (Shift 63)
    (68, Token (SEMICOLON _)) -> Just (Reduce 0 85)
    (68, Token (INFIXL _)) -> Just (Shift 289)
    (68, Token (INFIXR _)) -> Just (Shift 290)
    (68, Token (INFIX _)) -> Just (Shift 291)
    (68, Token (EXPORT _)) -> Just (Shift 93)
    (68, Token (AS _)) -> Just (Shift 94)
    (68, Token (QVARID _)) -> Just (Shift 95)
    (69, Token (LPAREN _)) -> Just (Shift 63)
    (69, Token (EQUAL _)) -> Just (Shift 47)
    (69, Token (PIPE _)) -> Just (Shift 53)
    (69, Token (MINUS _)) -> Just (Shift 61)
    (69, Token (EXPORT _)) -> Just (Shift 93)
    (69, Token (AS _)) -> Just (Shift 94)
    (69, Token (QVARID _)) -> Just (Shift 95)
    (69, Token (QVARSYM _)) -> Just (Shift 388)
    (69, Token (BACKQUOTE _)) -> Just (Shift 331)
    (69, Token (QCONSYM _)) -> Just (Shift 334)
    (70, Token (RBRACE _)) -> Just (Reduce 0 80)
    (70, Token (LPAREN _)) -> Just (Shift 63)
    (70, Token (SEMICOLON _)) -> Just (Reduce 0 80)
    (70, Token (EXPORT _)) -> Just (Shift 93)
    (70, Token (AS _)) -> Just (Shift 94)
    (70, Token (QVARID _)) -> Just (Shift 95)
    (71, Token (RBRACE _)) -> Just (Reduce 0 80)
    (71, Token (LPAREN _)) -> Just (Shift 63)
    (71, Token (SEMICOLON _)) -> Just (Reduce 0 80)
    (71, Token (EXPORT _)) -> Just (Shift 93)
    (71, Token (AS _)) -> Just (Shift 94)
    (71, Token (QVARID _)) -> Just (Shift 95)
    (72, Token (LPAREN _)) -> Just (Shift 63)
    (72, Token (EQUAL _)) -> Just (Shift 49)
    (72, Token (PIPE _)) -> Just (Shift 55)
    (72, Token (MINUS _)) -> Just (Shift 61)
    (72, Token (EXPORT _)) -> Just (Shift 93)
    (72, Token (AS _)) -> Just (Shift 94)
    (72, Token (QVARID _)) -> Just (Shift 95)
    (72, Token (QVARSYM _)) -> Just (Shift 388)
    (72, Token (BACKQUOTE _)) -> Just (Shift 331)
    (72, Token (QCONSYM _)) -> Just (Shift 334)
    (73, Token (LPAREN _)) -> Just (Shift 63)
    (73, Token (EQUAL _)) -> Just (Shift 50)
    (73, Token (PIPE _)) -> Just (Shift 56)
    (73, Token (MINUS _)) -> Just (Shift 61)
    (73, Token (EXPORT _)) -> Just (Shift 93)
    (73, Token (AS _)) -> Just (Shift 94)
    (73, Token (QVARID _)) -> Just (Shift 95)
    (73, Token (QVARSYM _)) -> Just (Shift 388)
    (73, Token (BACKQUOTE _)) -> Just (Shift 331)
    (73, Token (QCONSYM _)) -> Just (Shift 334)
    (74, Token (LPAREN _)) -> Just (Shift 63)
    (74, Token (EXPORT _)) -> Just (Shift 93)
    (74, Token (AS _)) -> Just (Shift 94)
    (74, Token (QVARID _)) -> Just (Shift 95)
    (75, Token (LPAREN _)) -> Just (Shift 63)
    (75, Token (MINUS _)) -> Just (Shift 61)
    (75, Token (RARROW _)) -> Just (Shift 35)
    (75, Token (EXPORT _)) -> Just (Shift 93)
    (75, Token (AS _)) -> Just (Shift 94)
    (75, Token (QVARID _)) -> Just (Shift 95)
    (75, Token (QVARSYM _)) -> Just (Shift 388)
    (75, Token (BACKQUOTE _)) -> Just (Shift 331)
    (75, Token (QCONSYM _)) -> Just (Shift 334)
    (76, Token (LPAREN _)) -> Just (Shift 88)
    (76, Token (RPAREN _)) -> Just (Reduce 0 15)
    (76, Token (QCONID _)) -> Just (Shift 144)
    (76, Token (EXPORT _)) -> Just (Shift 93)
    (76, Token (AS _)) -> Just (Shift 94)
    (76, Token (QVARID _)) -> Just (Shift 95)
    (77, Token (LPAREN _)) -> Just (Shift 88)
    (77, Token (RPAREN _)) -> Just (Reduce 0 15)
    (77, Token (QCONID _)) -> Just (Shift 144)
    (77, Token (EXPORT _)) -> Just (Shift 93)
    (77, Token (AS _)) -> Just (Shift 94)
    (77, Token (QVARID _)) -> Just (Shift 95)
    (78, Token (LPAREN _)) -> Just (Shift 88)
    (78, Token (RPAREN _)) -> Just (Reduce 0 15)
    (78, Token (QCONID _)) -> Just (Shift 144)
    (78, Token (EXPORT _)) -> Just (Shift 93)
    (78, Token (AS _)) -> Just (Shift 94)
    (78, Token (QVARID _)) -> Just (Shift 95)
    (79, Token (LPAREN _)) -> Just (Shift 88)
    (79, Token (QCONID _)) -> Just (Shift 144)
    (79, Token (EXPORT _)) -> Just (Shift 93)
    (79, Token (AS _)) -> Just (Shift 94)
    (79, Token (QVARID _)) -> Just (Shift 95)
    (80, Token (LPAREN _)) -> Just (Shift 88)
    (80, Token (RPAREN _)) -> Just (Shift 150)
    (80, Token (DOT_DOT _)) -> Just (Shift 153)
    (80, Token (QCONID _)) -> Just (Shift 144)
    (80, Token (EXPORT _)) -> Just (Shift 93)
    (80, Token (AS _)) -> Just (Shift 94)
    (80, Token (QVARID _)) -> Just (Shift 95)
    (81, Token (LPAREN _)) -> Just (Shift 89)
    (81, Token (EXPORT _)) -> Just (Shift 93)
    (81, Token (AS _)) -> Just (Shift 94)
    (81, Token (QVARID _)) -> Just (Shift 95)
    (82, Token (RBRACE _)) -> Just (Shift 327)
    (82, Token (LPAREN _)) -> Just (Shift 89)
    (82, Token (EXPORT _)) -> Just (Shift 93)
    (82, Token (AS _)) -> Just (Shift 94)
    (82, Token (QVARID _)) -> Just (Shift 95)
    (83, Token (LPAREN _)) -> Just (Shift 89)
    (83, Token (EXPORT _)) -> Just (Shift 93)
    (83, Token (AS _)) -> Just (Shift 94)
    (83, Token (QVARID _)) -> Just (Shift 95)
    (84, Token (LPAREN _)) -> Just (Shift 89)
    (84, Token (EXPORT _)) -> Just (Shift 93)
    (84, Token (AS _)) -> Just (Shift 94)
    (84, Token (QVARID _)) -> Just (Shift 95)
    (85, Token (LPAREN _)) -> Just (Shift 89)
    (85, Token (EXPORT _)) -> Just (Shift 93)
    (85, Token (AS _)) -> Just (Shift 94)
    (85, Token (QVARID _)) -> Just (Shift 95)
    (86, Token (LPAREN _)) -> Just (Shift 89)
    (86, Token (EXPORT _)) -> Just (Shift 93)
    (86, Token (AS _)) -> Just (Shift 94)
    (86, Token (QVARID _)) -> Just (Shift 95)
    (87, Token (LPAREN _)) -> Just (Shift 89)
    (87, Token (EXPORT _)) -> Just (Shift 93)
    (87, Token (AS _)) -> Just (Shift 94)
    (87, Token (QVARID _)) -> Just (Shift 95)
    (88, Token (MINUS _)) -> Just (Shift 92)
    (88, Token (QVARSYM _)) -> Just (Shift 96)
    (88, Token (QCONSYM _)) -> Just (Shift 145)
    (89, Token (MINUS _)) -> Just (Shift 92)
    (89, Token (QVARSYM _)) -> Just (Shift 96)
    (90, Token (WHERE _)) -> Just (Reduce 3 184)
    (90, Token (LBRACE _)) -> Just (Reduce 3 184)
    (90, Token (RBRACE _)) -> Just (Reduce 3 184)
    (90, Token (LPAREN _)) -> Just (Reduce 3 184)
    (90, Token (RPAREN _)) -> Just (Reduce 3 184)
    (90, Token (COMMA _)) -> Just (Reduce 3 184)
    (90, Token (SEMICOLON _)) -> Just (Reduce 3 184)
    (90, Token (EQUAL _)) -> Just (Reduce 3 184)
    (90, Token (PIPE _)) -> Just (Reduce 3 184)
    (90, Token (COLON_COLON _)) -> Just (Reduce 3 184)
    (90, Token (MINUS _)) -> Just (Reduce 3 184)
    (90, Token (INFIXL _)) -> Just (Reduce 3 184)
    (90, Token (INFIXR _)) -> Just (Reduce 3 184)
    (90, Token (INFIX _)) -> Just (Reduce 3 184)
    (90, Token (RARROW _)) -> Just (Reduce 3 184)
    (90, Token (QCONID _)) -> Just (Reduce 3 184)
    (90, Token (EXPORT _)) -> Just (Reduce 3 184)
    (90, Token (AS _)) -> Just (Reduce 3 184)
    (90, Token (QVARID _)) -> Just (Reduce 3 184)
    (90, Token (STRING _)) -> Just (Reduce 3 184)
    (90, Token (LARROW _)) -> Just (Reduce 3 184)
    (90, Token (LET _)) -> Just (Reduce 3 184)
    (90, Token (LAMBDA _)) -> Just (Reduce 3 184)
    (90, Token (IF _)) -> Just (Reduce 3 184)
    (90, Token (THEN _)) -> Just (Reduce 3 184)
    (90, Token (ELSE _)) -> Just (Reduce 3 184)
    (90, Token (QVARSYM _)) -> Just (Reduce 3 184)
    (90, Token (BACKQUOTE _)) -> Just (Reduce 3 184)
    (90, Token (QCONSYM _)) -> Just (Reduce 3 184)
    (90, Token (INTEGER _)) -> Just (Reduce 3 184)
    (91, Token (WHERE _)) -> Just (Reduce 3 185)
    (91, Token (LBRACE _)) -> Just (Reduce 3 185)
    (91, Token (RBRACE _)) -> Just (Reduce 3 185)
    (91, Token (LPAREN _)) -> Just (Reduce 3 185)
    (91, Token (RPAREN _)) -> Just (Reduce 3 185)
    (91, Token (COMMA _)) -> Just (Reduce 3 185)
    (91, Token (SEMICOLON _)) -> Just (Reduce 3 185)
    (91, Token (EQUAL _)) -> Just (Reduce 3 185)
    (91, Token (PIPE _)) -> Just (Reduce 3 185)
    (91, Token (COLON_COLON _)) -> Just (Reduce 3 185)
    (91, Token (MINUS _)) -> Just (Reduce 3 185)
    (91, Token (INFIXL _)) -> Just (Reduce 3 185)
    (91, Token (INFIXR _)) -> Just (Reduce 3 185)
    (91, Token (INFIX _)) -> Just (Reduce 3 185)
    (91, Token (RARROW _)) -> Just (Reduce 3 185)
    (91, Token (QCONID _)) -> Just (Reduce 3 185)
    (91, Token (EXPORT _)) -> Just (Reduce 3 185)
    (91, Token (AS _)) -> Just (Reduce 3 185)
    (91, Token (QVARID _)) -> Just (Reduce 3 185)
    (91, Token (STRING _)) -> Just (Reduce 3 185)
    (91, Token (LARROW _)) -> Just (Reduce 3 185)
    (91, Token (LET _)) -> Just (Reduce 3 185)
    (91, Token (LAMBDA _)) -> Just (Reduce 3 185)
    (91, Token (IF _)) -> Just (Reduce 3 185)
    (91, Token (THEN _)) -> Just (Reduce 3 185)
    (91, Token (ELSE _)) -> Just (Reduce 3 185)
    (91, Token (QVARSYM _)) -> Just (Reduce 3 185)
    (91, Token (BACKQUOTE _)) -> Just (Reduce 3 185)
    (91, Token (QCONSYM _)) -> Just (Reduce 3 185)
    (91, Token (INTEGER _)) -> Just (Reduce 3 185)
    (92, Token (RPAREN _)) -> Just (Shift 90)
    (93, Token (WHERE _)) -> Just (Reduce 1 182)
    (93, Token (LBRACE _)) -> Just (Reduce 1 182)
    (93, Token (RBRACE _)) -> Just (Reduce 1 182)
    (93, Token (LPAREN _)) -> Just (Reduce 1 182)
    (93, Token (RPAREN _)) -> Just (Reduce 1 182)
    (93, Token (COMMA _)) -> Just (Reduce 1 182)
    (93, Token (SEMICOLON _)) -> Just (Reduce 1 182)
    (93, Token (EQUAL _)) -> Just (Reduce 1 182)
    (93, Token (PIPE _)) -> Just (Reduce 1 182)
    (93, Token (COLON_COLON _)) -> Just (Reduce 1 182)
    (93, Token (MINUS _)) -> Just (Reduce 1 182)
    (93, Token (INFIXL _)) -> Just (Reduce 1 182)
    (93, Token (INFIXR _)) -> Just (Reduce 1 182)
    (93, Token (INFIX _)) -> Just (Reduce 1 182)
    (93, Token (RARROW _)) -> Just (Reduce 1 182)
    (93, Token (QCONID _)) -> Just (Reduce 1 182)
    (93, Token (EXPORT _)) -> Just (Reduce 1 182)
    (93, Token (AS _)) -> Just (Reduce 1 182)
    (93, Token (QVARID _)) -> Just (Reduce 1 182)
    (93, Token (STRING _)) -> Just (Reduce 1 182)
    (93, Token (LARROW _)) -> Just (Reduce 1 182)
    (93, Token (LET _)) -> Just (Reduce 1 182)
    (93, Token (LAMBDA _)) -> Just (Reduce 1 182)
    (93, Token (IF _)) -> Just (Reduce 1 182)
    (93, Token (THEN _)) -> Just (Reduce 1 182)
    (93, Token (ELSE _)) -> Just (Reduce 1 182)
    (93, Token (QVARSYM _)) -> Just (Reduce 1 182)
    (93, Token (BACKQUOTE _)) -> Just (Reduce 1 182)
    (93, Token (QCONSYM _)) -> Just (Reduce 1 182)
    (93, Token (INTEGER _)) -> Just (Reduce 1 182)
    (94, Token (WHERE _)) -> Just (Reduce 1 181)
    (94, Token (LBRACE _)) -> Just (Reduce 1 181)
    (94, Token (RBRACE _)) -> Just (Reduce 1 181)
    (94, Token (LPAREN _)) -> Just (Reduce 1 181)
    (94, Token (RPAREN _)) -> Just (Reduce 1 181)
    (94, Token (COMMA _)) -> Just (Reduce 1 181)
    (94, Token (SEMICOLON _)) -> Just (Reduce 1 181)
    (94, Token (EQUAL _)) -> Just (Reduce 1 181)
    (94, Token (PIPE _)) -> Just (Reduce 1 181)
    (94, Token (COLON_COLON _)) -> Just (Reduce 1 181)
    (94, Token (MINUS _)) -> Just (Reduce 1 181)
    (94, Token (INFIXL _)) -> Just (Reduce 1 181)
    (94, Token (INFIXR _)) -> Just (Reduce 1 181)
    (94, Token (INFIX _)) -> Just (Reduce 1 181)
    (94, Token (RARROW _)) -> Just (Reduce 1 181)
    (94, Token (QCONID _)) -> Just (Reduce 1 181)
    (94, Token (EXPORT _)) -> Just (Reduce 1 181)
    (94, Token (AS _)) -> Just (Reduce 1 181)
    (94, Token (QVARID _)) -> Just (Reduce 1 181)
    (94, Token (STRING _)) -> Just (Reduce 1 181)
    (94, Token (LARROW _)) -> Just (Reduce 1 181)
    (94, Token (LET _)) -> Just (Reduce 1 181)
    (94, Token (LAMBDA _)) -> Just (Reduce 1 181)
    (94, Token (IF _)) -> Just (Reduce 1 181)
    (94, Token (THEN _)) -> Just (Reduce 1 181)
    (94, Token (ELSE _)) -> Just (Reduce 1 181)
    (94, Token (QVARSYM _)) -> Just (Reduce 1 181)
    (94, Token (BACKQUOTE _)) -> Just (Reduce 1 181)
    (94, Token (QCONSYM _)) -> Just (Reduce 1 181)
    (94, Token (INTEGER _)) -> Just (Reduce 1 181)
    (95, Token (WHERE _)) -> Just (Reduce 1 183)
    (95, Token (LBRACE _)) -> Just (Reduce 1 183)
    (95, Token (RBRACE _)) -> Just (Reduce 1 183)
    (95, Token (LPAREN _)) -> Just (Reduce 1 183)
    (95, Token (RPAREN _)) -> Just (Reduce 1 183)
    (95, Token (COMMA _)) -> Just (Reduce 1 183)
    (95, Token (SEMICOLON _)) -> Just (Reduce 1 183)
    (95, Token (EQUAL _)) -> Just (Reduce 1 183)
    (95, Token (PIPE _)) -> Just (Reduce 1 183)
    (95, Token (COLON_COLON _)) -> Just (Reduce 1 183)
    (95, Token (MINUS _)) -> Just (Reduce 1 183)
    (95, Token (INFIXL _)) -> Just (Reduce 1 183)
    (95, Token (INFIXR _)) -> Just (Reduce 1 183)
    (95, Token (INFIX _)) -> Just (Reduce 1 183)
    (95, Token (RARROW _)) -> Just (Reduce 1 183)
    (95, Token (QCONID _)) -> Just (Reduce 1 183)
    (95, Token (EXPORT _)) -> Just (Reduce 1 183)
    (95, Token (AS _)) -> Just (Reduce 1 183)
    (95, Token (QVARID _)) -> Just (Reduce 1 183)
    (95, Token (STRING _)) -> Just (Reduce 1 183)
    (95, Token (LARROW _)) -> Just (Reduce 1 183)
    (95, Token (LET _)) -> Just (Reduce 1 183)
    (95, Token (LAMBDA _)) -> Just (Reduce 1 183)
    (95, Token (IF _)) -> Just (Reduce 1 183)
    (95, Token (THEN _)) -> Just (Reduce 1 183)
    (95, Token (ELSE _)) -> Just (Reduce 1 183)
    (95, Token (QVARSYM _)) -> Just (Reduce 1 183)
    (95, Token (BACKQUOTE _)) -> Just (Reduce 1 183)
    (95, Token (QCONSYM _)) -> Just (Reduce 1 183)
    (95, Token (INTEGER _)) -> Just (Reduce 1 183)
    (96, Token (RPAREN _)) -> Just (Shift 91)
    (97, Token (LPAREN _)) -> Just (Shift 137)
    (97, Token (LBRACKET _)) -> Just (Shift 141)
    (97, Token (EXCL _)) -> Just (Shift 97)
    (97, Token (QCONID _)) -> Just (Shift 144)
    (97, Token (EXPORT _)) -> Just (Shift 318)
    (97, Token (AS _)) -> Just (Shift 319)
    (97, Token (QVARID _)) -> Just (Shift 320)
    (98, Token (LPAREN _)) -> Just (Shift 137)
    (98, Token (LBRACKET _)) -> Just (Shift 141)
    (98, Token (EXCL _)) -> Just (Shift 97)
    (98, Token (QCONID _)) -> Just (Shift 144)
    (98, Token (EXPORT _)) -> Just (Shift 318)
    (98, Token (AS _)) -> Just (Shift 319)
    (98, Token (QVARID _)) -> Just (Shift 320)
    (99, Token (WHERE _)) -> Just (Shift 221)
    (99, Token (RBRACE _)) -> Just (Reduce 0 65)
    (99, Token (LPAREN _)) -> Just (Shift 137)
    (99, Token (SEMICOLON _)) -> Just (Reduce 0 65)
    (99, Token (DARROW _)) -> Just (Shift 102)
    (99, Token (LBRACKET _)) -> Just (Shift 141)
    (99, Token (EXCL _)) -> Just (Shift 97)
    (99, Token (QCONID _)) -> Just (Shift 144)
    (99, Token (EXPORT _)) -> Just (Shift 318)
    (99, Token (AS _)) -> Just (Shift 319)
    (99, Token (QVARID _)) -> Just (Shift 320)
    (100, Token (LPAREN _)) -> Just (Shift 137)
    (100, Token (LBRACKET _)) -> Just (Shift 141)
    (100, Token (EXCL _)) -> Just (Shift 97)
    (100, Token (QCONID _)) -> Just (Shift 144)
    (100, Token (EXPORT _)) -> Just (Shift 318)
    (100, Token (AS _)) -> Just (Shift 319)
    (100, Token (QVARID _)) -> Just (Shift 320)
    (101, Token (WHERE _)) -> Just (Shift 223)
    (101, Token (RBRACE _)) -> Just (Reduce 0 75)
    (101, Token (LPAREN _)) -> Just (Shift 137)
    (101, Token (SEMICOLON _)) -> Just (Reduce 0 75)
    (101, Token (DARROW _)) -> Just (Shift 104)
    (101, Token (LBRACKET _)) -> Just (Shift 141)
    (101, Token (EXCL _)) -> Just (Shift 97)
    (101, Token (QCONID _)) -> Just (Shift 144)
    (101, Token (EXPORT _)) -> Just (Shift 318)
    (101, Token (AS _)) -> Just (Shift 319)
    (101, Token (QVARID _)) -> Just (Shift 320)
    (102, Token (LPAREN _)) -> Just (Shift 137)
    (102, Token (LBRACKET _)) -> Just (Shift 141)
    (102, Token (EXCL _)) -> Just (Shift 97)
    (102, Token (QCONID _)) -> Just (Shift 144)
    (102, Token (EXPORT _)) -> Just (Shift 318)
    (102, Token (AS _)) -> Just (Shift 319)
    (102, Token (QVARID _)) -> Just (Shift 320)
    (103, Token (WHERE _)) -> Just (Shift 221)
    (103, Token (RBRACE _)) -> Just (Reduce 0 65)
    (103, Token (LPAREN _)) -> Just (Shift 137)
    (103, Token (SEMICOLON _)) -> Just (Reduce 0 65)
    (103, Token (LBRACKET _)) -> Just (Shift 141)
    (103, Token (EXCL _)) -> Just (Shift 97)
    (103, Token (QCONID _)) -> Just (Shift 144)
    (103, Token (EXPORT _)) -> Just (Shift 318)
    (103, Token (AS _)) -> Just (Shift 319)
    (103, Token (QVARID _)) -> Just (Shift 320)
    (104, Token (LPAREN _)) -> Just (Shift 137)
    (104, Token (LBRACKET _)) -> Just (Shift 141)
    (104, Token (EXCL _)) -> Just (Shift 97)
    (104, Token (QCONID _)) -> Just (Shift 144)
    (104, Token (EXPORT _)) -> Just (Shift 318)
    (104, Token (AS _)) -> Just (Shift 319)
    (104, Token (QVARID _)) -> Just (Shift 320)
    (105, Token (WHERE _)) -> Just (Shift 223)
    (105, Token (RBRACE _)) -> Just (Reduce 0 75)
    (105, Token (LPAREN _)) -> Just (Shift 137)
    (105, Token (SEMICOLON _)) -> Just (Reduce 0 75)
    (105, Token (LBRACKET _)) -> Just (Shift 141)
    (105, Token (EXCL _)) -> Just (Shift 97)
    (105, Token (QCONID _)) -> Just (Shift 144)
    (105, Token (EXPORT _)) -> Just (Shift 318)
    (105, Token (AS _)) -> Just (Shift 319)
    (105, Token (QVARID _)) -> Just (Shift 320)
    (106, Token (LPAREN _)) -> Just (Shift 137)
    (106, Token (LBRACKET _)) -> Just (Shift 141)
    (106, Token (EXCL _)) -> Just (Shift 97)
    (106, Token (QCONID _)) -> Just (Shift 144)
    (106, Token (EXPORT _)) -> Just (Shift 318)
    (106, Token (AS _)) -> Just (Shift 319)
    (106, Token (QVARID _)) -> Just (Shift 320)
    (107, Token (WHERE _)) -> Just (Reduce 1 100)
    (107, Token (RBRACE _)) -> Just (Reduce 1 100)
    (107, Token (LPAREN _)) -> Just (Shift 137)
    (107, Token (RPAREN _)) -> Just (Reduce 1 100)
    (107, Token (COMMA _)) -> Just (Reduce 1 100)
    (107, Token (SEMICOLON _)) -> Just (Reduce 1 100)
    (107, Token (EQUAL _)) -> Just (Reduce 1 100)
    (107, Token (DARROW _)) -> Just (Shift 109)
    (107, Token (PIPE _)) -> Just (Reduce 1 100)
    (107, Token (RARROW _)) -> Just (Shift 108)
    (107, Token (LBRACKET _)) -> Just (Shift 141)
    (107, Token (EXCL _)) -> Just (Shift 97)
    (107, Token (QCONID _)) -> Just (Shift 144)
    (107, Token (EXPORT _)) -> Just (Shift 318)
    (107, Token (AS _)) -> Just (Shift 319)
    (107, Token (QVARID _)) -> Just (Shift 320)
    (107, Token (LARROW _)) -> Just (Reduce 1 100)
    (107, Token (THEN _)) -> Just (Reduce 1 100)
    (107, Token (ELSE _)) -> Just (Reduce 1 100)
    (108, Token (LPAREN _)) -> Just (Shift 137)
    (108, Token (LBRACKET _)) -> Just (Shift 141)
    (108, Token (EXCL _)) -> Just (Shift 97)
    (108, Token (QCONID _)) -> Just (Shift 144)
    (108, Token (EXPORT _)) -> Just (Shift 318)
    (108, Token (AS _)) -> Just (Shift 319)
    (108, Token (QVARID _)) -> Just (Shift 320)
    (109, Token (LPAREN _)) -> Just (Shift 137)
    (109, Token (LBRACKET _)) -> Just (Shift 141)
    (109, Token (EXCL _)) -> Just (Shift 97)
    (109, Token (QCONID _)) -> Just (Shift 144)
    (109, Token (EXPORT _)) -> Just (Shift 318)
    (109, Token (AS _)) -> Just (Shift 319)
    (109, Token (QVARID _)) -> Just (Shift 320)
    (110, Token (WHERE _)) -> Just (Reduce 1 100)
    (110, Token (RBRACE _)) -> Just (Reduce 1 100)
    (110, Token (LPAREN _)) -> Just (Shift 137)
    (110, Token (RPAREN _)) -> Just (Reduce 1 100)
    (110, Token (COMMA _)) -> Just (Reduce 1 100)
    (110, Token (SEMICOLON _)) -> Just (Reduce 1 100)
    (110, Token (EQUAL _)) -> Just (Reduce 1 100)
    (110, Token (PIPE _)) -> Just (Reduce 1 100)
    (110, Token (RARROW _)) -> Just (Shift 108)
    (110, Token (LBRACKET _)) -> Just (Shift 141)
    (110, Token (RBRACKET _)) -> Just (Reduce 1 100)
    (110, Token (EXCL _)) -> Just (Shift 97)
    (110, Token (QCONID _)) -> Just (Shift 144)
    (110, Token (EXPORT _)) -> Just (Shift 318)
    (110, Token (AS _)) -> Just (Shift 319)
    (110, Token (QVARID _)) -> Just (Shift 320)
    (110, Token (LARROW _)) -> Just (Reduce 1 100)
    (110, Token (THEN _)) -> Just (Reduce 1 100)
    (110, Token (ELSE _)) -> Just (Reduce 1 100)
    (111, Token (LPAREN _)) -> Just (Shift 137)
    (111, Token (LBRACKET _)) -> Just (Shift 141)
    (111, Token (EXCL _)) -> Just (Shift 97)
    (111, Token (QCONID _)) -> Just (Shift 144)
    (111, Token (EXPORT _)) -> Just (Shift 318)
    (111, Token (AS _)) -> Just (Shift 319)
    (111, Token (QVARID _)) -> Just (Shift 320)
    (112, Token (RBRACE _)) -> Just (Reduce 0 119)
    (112, Token (LPAREN _)) -> Just (Shift 137)
    (112, Token (SEMICOLON _)) -> Just (Reduce 0 119)
    (112, Token (EQUAL _)) -> Just (Shift 115)
    (112, Token (DERIVING _)) -> Just (Reduce 0 119)
    (112, Token (DARROW _)) -> Just (Shift 113)
    (112, Token (LBRACKET _)) -> Just (Shift 141)
    (112, Token (EXCL _)) -> Just (Shift 97)
    (112, Token (QCONID _)) -> Just (Shift 144)
    (112, Token (EXPORT _)) -> Just (Shift 318)
    (112, Token (AS _)) -> Just (Shift 319)
    (112, Token (QVARID _)) -> Just (Shift 320)
    (113, Token (LPAREN _)) -> Just (Shift 137)
    (113, Token (LBRACKET _)) -> Just (Shift 141)
    (113, Token (EXCL _)) -> Just (Shift 97)
    (113, Token (QCONID _)) -> Just (Shift 144)
    (113, Token (EXPORT _)) -> Just (Shift 318)
    (113, Token (AS _)) -> Just (Shift 319)
    (113, Token (QVARID _)) -> Just (Shift 320)
    (114, Token (RBRACE _)) -> Just (Reduce 0 119)
    (114, Token (LPAREN _)) -> Just (Shift 137)
    (114, Token (SEMICOLON _)) -> Just (Reduce 0 119)
    (114, Token (EQUAL _)) -> Just (Shift 115)
    (114, Token (DERIVING _)) -> Just (Reduce 0 119)
    (114, Token (LBRACKET _)) -> Just (Shift 141)
    (114, Token (EXCL _)) -> Just (Shift 97)
    (114, Token (QCONID _)) -> Just (Shift 144)
    (114, Token (EXPORT _)) -> Just (Shift 318)
    (114, Token (AS _)) -> Just (Shift 319)
    (114, Token (QVARID _)) -> Just (Shift 320)
    (115, Token (LPAREN _)) -> Just (Shift 137)
    (115, Token (LBRACKET _)) -> Just (Shift 141)
    (115, Token (EXCL _)) -> Just (Shift 97)
    (115, Token (QCONID _)) -> Just (Shift 144)
    (115, Token (EXPORT _)) -> Just (Shift 318)
    (115, Token (AS _)) -> Just (Shift 319)
    (115, Token (QVARID _)) -> Just (Shift 320)
    (116, Token (LPAREN _)) -> Just (Shift 137)
    (116, Token (LBRACKET _)) -> Just (Shift 141)
    (116, Token (EXCL _)) -> Just (Shift 97)
    (116, Token (QCONID _)) -> Just (Shift 144)
    (116, Token (EXPORT _)) -> Just (Shift 318)
    (116, Token (AS _)) -> Just (Shift 319)
    (116, Token (QVARID _)) -> Just (Shift 320)
    (117, Token (LPAREN _)) -> Just (Shift 142)
    (117, Token (QCONID _)) -> Just (Shift 144)
    (118, Token (RBRACE _)) -> Just (Reduce 1 123)
    (118, Token (LPAREN _)) -> Just (Shift 137)
    (118, Token (SEMICOLON _)) -> Just (Reduce 1 123)
    (118, Token (DERIVING _)) -> Just (Reduce 1 123)
    (118, Token (PIPE _)) -> Just (Reduce 1 123)
    (118, Token (LBRACKET _)) -> Just (Shift 141)
    (118, Token (EXCL _)) -> Just (Shift 97)
    (118, Token (QCONID _)) -> Just (Shift 144)
    (118, Token (EXPORT _)) -> Just (Shift 318)
    (118, Token (AS _)) -> Just (Shift 319)
    (118, Token (QVARID _)) -> Just (Shift 320)
    (118, Token (BACKQUOTE _)) -> Just (Shift 332)
    (118, Token (QCONSYM _)) -> Just (Shift 334)
    (119, Token (LPAREN _)) -> Just (Shift 137)
    (119, Token (LBRACKET _)) -> Just (Shift 141)
    (119, Token (EXCL _)) -> Just (Shift 97)
    (119, Token (QCONID _)) -> Just (Shift 144)
    (119, Token (EXPORT _)) -> Just (Shift 318)
    (119, Token (AS _)) -> Just (Shift 319)
    (119, Token (QVARID _)) -> Just (Shift 320)
    (120, Token (RBRACE _)) -> Just (Reduce 3 124)
    (120, Token (LPAREN _)) -> Just (Shift 137)
    (120, Token (SEMICOLON _)) -> Just (Reduce 3 124)
    (120, Token (DERIVING _)) -> Just (Reduce 3 124)
    (120, Token (PIPE _)) -> Just (Reduce 3 124)
    (120, Token (LBRACKET _)) -> Just (Shift 141)
    (120, Token (EXCL _)) -> Just (Shift 97)
    (120, Token (QCONID _)) -> Just (Shift 144)
    (120, Token (EXPORT _)) -> Just (Shift 318)
    (120, Token (AS _)) -> Just (Shift 319)
    (120, Token (QVARID _)) -> Just (Shift 320)
    (121, Token (LPAREN _)) -> Just (Shift 137)
    (121, Token (LBRACKET _)) -> Just (Shift 141)
    (121, Token (EXCL _)) -> Just (Shift 97)
    (121, Token (QCONID _)) -> Just (Shift 144)
    (121, Token (EXPORT _)) -> Just (Shift 318)
    (121, Token (AS _)) -> Just (Shift 319)
    (121, Token (QVARID _)) -> Just (Shift 320)
    (122, Token (RBRACE _)) -> Just (Reduce 1 100)
    (122, Token (LPAREN _)) -> Just (Shift 137)
    (122, Token (SEMICOLON _)) -> Just (Reduce 1 100)
    (122, Token (DARROW _)) -> Just (Shift 127)
    (122, Token (RARROW _)) -> Just (Shift 108)
    (122, Token (LBRACKET _)) -> Just (Shift 141)
    (122, Token (EXCL _)) -> Just (Shift 97)
    (122, Token (QCONID _)) -> Just (Shift 144)
    (122, Token (EXPORT _)) -> Just (Shift 318)
    (122, Token (AS _)) -> Just (Shift 319)
    (122, Token (QVARID _)) -> Just (Shift 320)
    (123, Token (LPAREN _)) -> Just (Shift 137)
    (123, Token (LBRACKET _)) -> Just (Shift 141)
    (123, Token (EXCL _)) -> Just (Shift 97)
    (123, Token (QCONID _)) -> Just (Shift 144)
    (123, Token (EXPORT _)) -> Just (Shift 318)
    (123, Token (AS _)) -> Just (Shift 319)
    (123, Token (QVARID _)) -> Just (Shift 320)
    (124, Token (LPAREN _)) -> Just (Shift 137)
    (124, Token (LBRACKET _)) -> Just (Shift 141)
    (124, Token (EXCL _)) -> Just (Shift 97)
    (124, Token (QCONID _)) -> Just (Shift 144)
    (124, Token (EXPORT _)) -> Just (Shift 318)
    (124, Token (AS _)) -> Just (Shift 319)
    (124, Token (QVARID _)) -> Just (Shift 320)
    (125, Token (LPAREN _)) -> Just (Shift 137)
    (125, Token (LBRACKET _)) -> Just (Shift 141)
    (125, Token (EXCL _)) -> Just (Shift 97)
    (125, Token (QCONID _)) -> Just (Shift 144)
    (125, Token (EXPORT _)) -> Just (Shift 318)
    (125, Token (AS _)) -> Just (Shift 319)
    (125, Token (QVARID _)) -> Just (Shift 320)
    (126, Token (LPAREN _)) -> Just (Shift 137)
    (126, Token (LBRACKET _)) -> Just (Shift 141)
    (126, Token (EXCL _)) -> Just (Shift 97)
    (126, Token (QCONID _)) -> Just (Shift 144)
    (126, Token (EXPORT _)) -> Just (Shift 318)
    (126, Token (AS _)) -> Just (Shift 319)
    (126, Token (QVARID _)) -> Just (Shift 320)
    (127, Token (LPAREN _)) -> Just (Shift 137)
    (127, Token (LBRACKET _)) -> Just (Shift 141)
    (127, Token (EXCL _)) -> Just (Shift 97)
    (127, Token (QCONID _)) -> Just (Shift 144)
    (127, Token (EXPORT _)) -> Just (Shift 318)
    (127, Token (AS _)) -> Just (Shift 319)
    (127, Token (QVARID _)) -> Just (Shift 320)
    (128, Token (LPAREN _)) -> Just (Shift 137)
    (128, Token (LBRACKET _)) -> Just (Shift 141)
    (128, Token (EXCL _)) -> Just (Shift 97)
    (128, Token (QCONID _)) -> Just (Shift 144)
    (128, Token (EXPORT _)) -> Just (Shift 318)
    (128, Token (AS _)) -> Just (Shift 319)
    (128, Token (QVARID _)) -> Just (Shift 320)
    (129, Token (LPAREN _)) -> Just (Shift 137)
    (129, Token (LBRACKET _)) -> Just (Shift 141)
    (129, Token (EXCL _)) -> Just (Shift 97)
    (129, Token (QCONID _)) -> Just (Shift 144)
    (129, Token (EXPORT _)) -> Just (Shift 318)
    (129, Token (AS _)) -> Just (Shift 319)
    (129, Token (QVARID _)) -> Just (Shift 320)
    (130, Token (LBRACE _)) -> Just (Shift 84)
    (130, Token (LPAREN _)) -> Just (Shift 137)
    (130, Token (LBRACKET _)) -> Just (Shift 141)
    (130, Token (EXCL _)) -> Just (Shift 97)
    (130, Token (QCONID _)) -> Just (Shift 144)
    (130, Token (EXPORT _)) -> Just (Shift 318)
    (130, Token (AS _)) -> Just (Shift 319)
    (130, Token (QVARID _)) -> Just (Shift 320)
    (131, Token (LPAREN _)) -> Just (Shift 137)
    (131, Token (LBRACKET _)) -> Just (Shift 141)
    (131, Token (EXCL _)) -> Just (Shift 97)
    (131, Token (QCONID _)) -> Just (Shift 144)
    (131, Token (EXPORT _)) -> Just (Shift 318)
    (131, Token (AS _)) -> Just (Shift 319)
    (131, Token (QVARID _)) -> Just (Shift 320)
    (132, Token (LPAREN _)) -> Just (Shift 137)
    (132, Token (EQUAL _)) -> Just (Shift 117)
    (132, Token (DARROW _)) -> Just (Shift 134)
    (132, Token (LBRACKET _)) -> Just (Shift 141)
    (132, Token (EXCL _)) -> Just (Shift 97)
    (132, Token (QCONID _)) -> Just (Shift 144)
    (132, Token (EXPORT _)) -> Just (Shift 318)
    (132, Token (AS _)) -> Just (Shift 319)
    (132, Token (QVARID _)) -> Just (Shift 320)
    (133, Token (LPAREN _)) -> Just (Shift 137)
    (133, Token (LBRACKET _)) -> Just (Shift 141)
    (133, Token (EXCL _)) -> Just (Shift 97)
    (133, Token (QCONID _)) -> Just (Shift 144)
    (133, Token (EXPORT _)) -> Just (Shift 318)
    (133, Token (AS _)) -> Just (Shift 319)
    (133, Token (QVARID _)) -> Just (Shift 320)
    (134, Token (LPAREN _)) -> Just (Shift 137)
    (134, Token (LBRACKET _)) -> Just (Shift 141)
    (134, Token (EXCL _)) -> Just (Shift 97)
    (134, Token (QCONID _)) -> Just (Shift 144)
    (134, Token (EXPORT _)) -> Just (Shift 318)
    (134, Token (AS _)) -> Just (Shift 319)
    (134, Token (QVARID _)) -> Just (Shift 320)
    (135, Token (LPAREN _)) -> Just (Shift 137)
    (135, Token (EQUAL _)) -> Just (Shift 123)
    (135, Token (LBRACKET _)) -> Just (Shift 141)
    (135, Token (EXCL _)) -> Just (Shift 97)
    (135, Token (QCONID _)) -> Just (Shift 144)
    (135, Token (EXPORT _)) -> Just (Shift 318)
    (135, Token (AS _)) -> Just (Shift 319)
    (135, Token (QVARID _)) -> Just (Shift 320)
    (136, Token (LPAREN _)) -> Just (Shift 137)
    (136, Token (EQUAL _)) -> Just (Shift 117)
    (136, Token (LBRACKET _)) -> Just (Shift 141)
    (136, Token (EXCL _)) -> Just (Shift 97)
    (136, Token (QCONID _)) -> Just (Shift 144)
    (136, Token (EXPORT _)) -> Just (Shift 318)
    (136, Token (AS _)) -> Just (Shift 319)
    (136, Token (QVARID _)) -> Just (Shift 320)
    (137, Token (LPAREN _)) -> Just (Shift 137)
    (137, Token (RPAREN _)) -> Just (Shift 310)
    (137, Token (COMMA _)) -> Just (Shift 323)
    (137, Token (RARROW _)) -> Just (Shift 313)
    (137, Token (LBRACKET _)) -> Just (Shift 141)
    (137, Token (EXCL _)) -> Just (Shift 97)
    (137, Token (QCONID _)) -> Just (Shift 144)
    (137, Token (EXPORT _)) -> Just (Shift 318)
    (137, Token (AS _)) -> Just (Shift 319)
    (137, Token (QVARID _)) -> Just (Shift 320)
    (137, Token (QCONSYM _)) -> Just (Shift 145)
    (138, Token (LPAREN _)) -> Just (Shift 137)
    (138, Token (RPAREN _)) -> Just (Shift 167)
    (138, Token (LBRACKET _)) -> Just (Shift 141)
    (138, Token (EXCL _)) -> Just (Shift 97)
    (138, Token (QCONID _)) -> Just (Shift 144)
    (138, Token (EXPORT _)) -> Just (Shift 318)
    (138, Token (AS _)) -> Just (Shift 319)
    (138, Token (QVARID _)) -> Just (Shift 320)
    (139, Token (LPAREN _)) -> Just (Shift 137)
    (139, Token (LBRACKET _)) -> Just (Shift 141)
    (139, Token (EXCL _)) -> Just (Shift 97)
    (139, Token (QCONID _)) -> Just (Shift 144)
    (139, Token (EXPORT _)) -> Just (Shift 318)
    (139, Token (AS _)) -> Just (Shift 319)
    (139, Token (QVARID _)) -> Just (Shift 320)
    (140, Token (LPAREN _)) -> Just (Shift 137)
    (140, Token (LBRACKET _)) -> Just (Shift 141)
    (140, Token (EXCL _)) -> Just (Shift 97)
    (140, Token (QCONID _)) -> Just (Shift 144)
    (140, Token (EXPORT _)) -> Just (Shift 318)
    (140, Token (AS _)) -> Just (Shift 319)
    (140, Token (QVARID _)) -> Just (Shift 320)
    (141, Token (LPAREN _)) -> Just (Shift 137)
    (141, Token (LBRACKET _)) -> Just (Shift 141)
    (141, Token (RBRACKET _)) -> Just (Shift 314)
    (141, Token (EXCL _)) -> Just (Shift 97)
    (141, Token (QCONID _)) -> Just (Shift 144)
    (141, Token (EXPORT _)) -> Just (Shift 318)
    (141, Token (AS _)) -> Just (Shift 319)
    (141, Token (QVARID _)) -> Just (Shift 320)
    (142, Token (QCONSYM _)) -> Just (Shift 145)
    (143, Token (WHERE _)) -> Just (Reduce 3 187)
    (143, Token (LBRACE _)) -> Just (Reduce 3 187)
    (143, Token (RBRACE _)) -> Just (Reduce 3 187)
    (143, Token (LPAREN _)) -> Just (Reduce 3 187)
    (143, Token (RPAREN _)) -> Just (Reduce 3 187)
    (143, Token (COMMA _)) -> Just (Reduce 3 187)
    (143, Token (SEMICOLON _)) -> Just (Reduce 3 187)
    (143, Token (EQUAL _)) -> Just (Reduce 3 187)
    (143, Token (DERIVING _)) -> Just (Reduce 3 187)
    (143, Token (DARROW _)) -> Just (Reduce 3 187)
    (143, Token (PIPE _)) -> Just (Reduce 3 187)
    (143, Token (COLON_COLON _)) -> Just (Reduce 3 187)
    (143, Token (MINUS _)) -> Just (Reduce 3 187)
    (143, Token (INFIXL _)) -> Just (Reduce 3 187)
    (143, Token (INFIXR _)) -> Just (Reduce 3 187)
    (143, Token (INFIX _)) -> Just (Reduce 3 187)
    (143, Token (RARROW _)) -> Just (Reduce 3 187)
    (143, Token (LBRACKET _)) -> Just (Reduce 3 187)
    (143, Token (RBRACKET _)) -> Just (Reduce 3 187)
    (143, Token (EXCL _)) -> Just (Reduce 3 187)
    (143, Token (QCONID _)) -> Just (Reduce 3 187)
    (143, Token (EXPORT _)) -> Just (Reduce 3 187)
    (143, Token (AS _)) -> Just (Reduce 3 187)
    (143, Token (QVARID _)) -> Just (Reduce 3 187)
    (143, Token (LARROW _)) -> Just (Reduce 3 187)
    (143, Token (THEN _)) -> Just (Reduce 3 187)
    (143, Token (ELSE _)) -> Just (Reduce 3 187)
    (143, Token (QVARSYM _)) -> Just (Reduce 3 187)
    (143, Token (BACKQUOTE _)) -> Just (Reduce 3 187)
    (143, Token (QCONSYM _)) -> Just (Reduce 3 187)
    (143, Token (INTEGER _)) -> Just (Reduce 3 187)
    (144, Token (WHERE _)) -> Just (Reduce 1 186)
    (144, Token (LBRACE _)) -> Just (Reduce 1 186)
    (144, Token (RBRACE _)) -> Just (Reduce 1 186)
    (144, Token (LPAREN _)) -> Just (Reduce 1 186)
    (144, Token (RPAREN _)) -> Just (Reduce 1 186)
    (144, Token (COMMA _)) -> Just (Reduce 1 186)
    (144, Token (SEMICOLON _)) -> Just (Reduce 1 186)
    (144, Token (EQUAL _)) -> Just (Reduce 1 186)
    (144, Token (DERIVING _)) -> Just (Reduce 1 186)
    (144, Token (DARROW _)) -> Just (Reduce 1 186)
    (144, Token (PIPE _)) -> Just (Reduce 1 186)
    (144, Token (COLON_COLON _)) -> Just (Reduce 1 186)
    (144, Token (MINUS _)) -> Just (Reduce 1 186)
    (144, Token (INFIXL _)) -> Just (Reduce 1 186)
    (144, Token (INFIXR _)) -> Just (Reduce 1 186)
    (144, Token (INFIX _)) -> Just (Reduce 1 186)
    (144, Token (RARROW _)) -> Just (Reduce 1 186)
    (144, Token (LBRACKET _)) -> Just (Reduce 1 186)
    (144, Token (RBRACKET _)) -> Just (Reduce 1 186)
    (144, Token (EXCL _)) -> Just (Reduce 1 186)
    (144, Token (QCONID _)) -> Just (Reduce 1 186)
    (144, Token (EXPORT _)) -> Just (Reduce 1 186)
    (144, Token (AS _)) -> Just (Reduce 1 186)
    (144, Token (QVARID _)) -> Just (Reduce 1 186)
    (144, Token (LARROW _)) -> Just (Reduce 1 186)
    (144, Token (THEN _)) -> Just (Reduce 1 186)
    (144, Token (ELSE _)) -> Just (Reduce 1 186)
    (144, Token (QVARSYM _)) -> Just (Reduce 1 186)
    (144, Token (BACKQUOTE _)) -> Just (Reduce 1 186)
    (144, Token (QCONSYM _)) -> Just (Reduce 1 186)
    (144, Token (INTEGER _)) -> Just (Reduce 1 186)
    (145, Token (RPAREN _)) -> Just (Shift 143)
    (146, Token (RPAREN _)) -> Just (Reduce 3 24)
    (147, Token (RPAREN _)) -> Just (Reduce 1 23)
    (147, Token (COMMA _)) -> Just (Shift 79)
    (148, Token (RPAREN _)) -> Just (Reduce 3 17)
    (149, Token (RPAREN _)) -> Just (Reduce 1 16)
    (149, Token (COMMA _)) -> Just (Shift 76)
    (150, Token (RPAREN _)) -> Just (Reduce 3 20)
    (150, Token (COMMA _)) -> Just (Reduce 3 20)
    (151, Token (RPAREN _)) -> Just (Reduce 4 21)
    (151, Token (COMMA _)) -> Just (Reduce 4 21)
    (152, Token (RPAREN _)) -> Just (Reduce 4 22)
    (152, Token (COMMA _)) -> Just (Reduce 4 22)
    (153, Token (RPAREN _)) -> Just (Shift 151)
    (154, Token (RPAREN _)) -> Just (Reduce 1 18)
    (154, Token (COMMA _)) -> Just (Reduce 1 18)
    (155, Token (LPAREN _)) -> Just (Shift 80)
    (155, Token (RPAREN _)) -> Just (Reduce 1 19)
    (155, Token (COMMA _)) -> Just (Reduce 1 19)
    (156, Token (RPAREN _)) -> Just (Shift 152)
    (157, Token (RPAREN _)) -> Just (Reduce 1 25)
    (157, Token (COMMA _)) -> Just (Reduce 1 25)
    (158, Token (RPAREN _)) -> Just (Reduce 1 26)
    (158, Token (COMMA _)) -> Just (Reduce 1 26)
    (159, Token (RPAREN _)) -> Just (Shift 163)
    (159, Token (QCONID _)) -> Just (Shift 214)
    (160, Token (RPAREN _)) -> Just (Shift 164)
    (160, Token (QCONID _)) -> Just (Shift 214)
    (161, Token (RPAREN _)) -> Just (Shift 165)
    (161, Token (QCONID _)) -> Just (Shift 214)
    (162, Token (RPAREN _)) -> Just (Shift 166)
    (162, Token (QCONID _)) -> Just (Shift 214)
    (163, Token (RBRACE _)) -> Just (Reduce 6 35)
    (163, Token (SEMICOLON _)) -> Just (Reduce 6 35)
    (164, Token (RBRACE _)) -> Just (Reduce 8 39)
    (164, Token (SEMICOLON _)) -> Just (Reduce 8 39)
    (165, Token (RBRACE _)) -> Just (Reduce 8 47)
    (165, Token (SEMICOLON _)) -> Just (Reduce 8 47)
    (166, Token (RBRACE _)) -> Just (Reduce 6 43)
    (166, Token (SEMICOLON _)) -> Just (Reduce 6 43)
    (167, Token (RBRACE _)) -> Just (Reduce 3 53)
    (167, Token (SEMICOLON _)) -> Just (Reduce 3 53)
    (168, Token (RBRACE _)) -> Just (Reduce 8 31)
    (168, Token (SEMICOLON _)) -> Just (Reduce 8 31)
    (169, Token (RBRACE _)) -> Just (Reduce 7 30)
    (169, Token (SEMICOLON _)) -> Just (Reduce 7 30)
    (170, Token (RBRACE _)) -> Just (Reduce 7 36)
    (170, Token (SEMICOLON _)) -> Just (Reduce 7 36)
    (171, Token (RBRACE _)) -> Just (Reduce 9 40)
    (171, Token (SEMICOLON _)) -> Just (Reduce 9 40)
    (172, Token (RBRACE _)) -> Just (Reduce 9 48)
    (172, Token (SEMICOLON _)) -> Just (Reduce 9 48)
    (173, Token (RBRACE _)) -> Just (Reduce 7 44)
    (173, Token (SEMICOLON _)) -> Just (Reduce 7 44)
    (174, Token (RBRACE _)) -> Just (Reduce 4 54)
    (174, Token (SEMICOLON _)) -> Just (Reduce 4 54)
    (175, Token (QCONID _)) -> Just (Reduce 0 198)
    (175, Token (QUALIFIED _)) -> Just (Shift 207)
    (176, Token (LPAREN _)) -> Just (Shift 77)
    (177, Token (LPAREN _)) -> Just (Shift 159)
    (177, Token (QCONID _)) -> Just (Shift 214)
    (178, Token (LPAREN _)) -> Just (Shift 160)
    (178, Token (QCONID _)) -> Just (Shift 214)
    (179, Token (LPAREN _)) -> Just (Shift 161)
    (179, Token (QCONID _)) -> Just (Shift 214)
    (180, Token (LPAREN _)) -> Just (Shift 162)
    (180, Token (QCONID _)) -> Just (Shift 214)
    (181, Token (LPAREN _)) -> Just (Shift 138)
    (182, Token (IMPORT _)) -> Just (Shift 227)
    (182, Token (EXPORT _)) -> Just (Shift 228)
    (183, Token (RBRACE _)) -> Just (Reduce 0 196)
    (183, Token (LPAREN _)) -> Just (Reduce 0 196)
    (183, Token (SEMICOLON _)) -> Just (Reduce 0 196)
    (183, Token (HIDING _)) -> Just (Reduce 0 196)
    (183, Token (AS _)) -> Just (Shift 9)
    (184, Token (RPAREN _)) -> Just (Shift 168)
    (185, Token (RPAREN _)) -> Just (Shift 169)
    (186, Token (RBRACE _)) -> Just (Reduce 4 29)
    (186, Token (LPAREN _)) -> Just (Shift 78)
    (186, Token (SEMICOLON _)) -> Just (Reduce 4 29)
    (186, Token (HIDING _)) -> Just (Shift 176)
    (187, Token (RBRACE _)) -> Just (Reduce 4 32)
    (187, Token (SEMICOLON _)) -> Just (Reduce 4 32)
    (188, Token (RBRACE _)) -> Just (Reduce 3 33)
    (188, Token (SEMICOLON _)) -> Just (Reduce 3 33)
    (188, Token (DERIVING _)) -> Just (Shift 177)
    (189, Token (RBRACE _)) -> Just (Reduce 5 37)
    (189, Token (SEMICOLON _)) -> Just (Reduce 5 37)
    (189, Token (DERIVING _)) -> Just (Shift 178)
    (190, Token (RBRACE _)) -> Just (Reduce 5 34)
    (190, Token (SEMICOLON _)) -> Just (Reduce 5 34)
    (191, Token (RBRACE _)) -> Just (Reduce 7 38)
    (191, Token (SEMICOLON _)) -> Just (Reduce 7 38)
    (192, Token (RBRACE _)) -> Just (Reduce 7 46)
    (192, Token (SEMICOLON _)) -> Just (Reduce 7 46)
    (193, Token (RBRACE _)) -> Just (Reduce 5 42)
    (193, Token (SEMICOLON _)) -> Just (Reduce 5 42)
    (194, Token (RPAREN _)) -> Just (Shift 170)
    (195, Token (RPAREN _)) -> Just (Shift 171)
    (196, Token (RPAREN _)) -> Just (Shift 172)
    (197, Token (RPAREN _)) -> Just (Shift 173)
    (198, Token (RBRACE _)) -> Just (Reduce 5 45)
    (198, Token (SEMICOLON _)) -> Just (Reduce 5 45)
    (198, Token (DERIVING _)) -> Just (Shift 179)
    (199, Token (RBRACE _)) -> Just (Reduce 3 41)
    (199, Token (SEMICOLON _)) -> Just (Reduce 3 41)
    (199, Token (DERIVING _)) -> Just (Shift 180)
    (200, Token (RBRACE _)) -> Just (Reduce 5 50)
    (200, Token (SEMICOLON _)) -> Just (Reduce 5 50)
    (201, Token (RBRACE _)) -> Just (Reduce 3 49)
    (201, Token (SEMICOLON _)) -> Just (Reduce 3 49)
    (202, Token (RBRACE _)) -> Just (Reduce 5 52)
    (202, Token (SEMICOLON _)) -> Just (Reduce 5 52)
    (203, Token (RBRACE _)) -> Just (Reduce 3 51)
    (203, Token (SEMICOLON _)) -> Just (Reduce 3 51)
    (204, Token (RPAREN _)) -> Just (Shift 174)
    (205, Token (RBRACE _)) -> Just (Reduce 2 55)
    (205, Token (SEMICOLON _)) -> Just (Reduce 2 55)
    (206, Token (RBRACE _)) -> Just (Reduce 1 56)
    (206, Token (SEMICOLON _)) -> Just (Reduce 1 56)
    (207, Token (QCONID _)) -> Just (Reduce 1 199)
    (208, Token (RBRACE _)) -> Just (Reduce 2 197)
    (208, Token (LPAREN _)) -> Just (Reduce 2 197)
    (208, Token (SEMICOLON _)) -> Just (Reduce 2 197)
    (208, Token (HIDING _)) -> Just (Reduce 2 197)
    (209, Token (WHERE _)) -> Just (Reduce 1 102)
    (209, Token (LBRACE _)) -> Just (Reduce 1 102)
    (209, Token (RBRACE _)) -> Just (Reduce 1 102)
    (209, Token (LPAREN _)) -> Just (Reduce 1 102)
    (209, Token (RPAREN _)) -> Just (Reduce 1 102)
    (209, Token (COMMA _)) -> Just (Reduce 1 102)
    (209, Token (SEMICOLON _)) -> Just (Reduce 1 102)
    (209, Token (EQUAL _)) -> Just (Reduce 1 102)
    (209, Token (DERIVING _)) -> Just (Reduce 1 102)
    (209, Token (DARROW _)) -> Just (Reduce 1 102)
    (209, Token (PIPE _)) -> Just (Reduce 1 102)
    (209, Token (COLON_COLON _)) -> Just (Reduce 1 102)
    (209, Token (MINUS _)) -> Just (Reduce 1 102)
    (209, Token (INFIXL _)) -> Just (Reduce 1 102)
    (209, Token (INFIXR _)) -> Just (Reduce 1 102)
    (209, Token (INFIX _)) -> Just (Reduce 1 102)
    (209, Token (RARROW _)) -> Just (Reduce 1 102)
    (209, Token (LBRACKET _)) -> Just (Reduce 1 102)
    (209, Token (RBRACKET _)) -> Just (Reduce 1 102)
    (209, Token (EXCL _)) -> Just (Reduce 1 102)
    (209, Token (QCONID _)) -> Just (Reduce 1 102)
    (209, Token (EXPORT _)) -> Just (Reduce 1 102)
    (209, Token (AS _)) -> Just (Reduce 1 102)
    (209, Token (QVARID _)) -> Just (Reduce 1 102)
    (209, Token (LARROW _)) -> Just (Reduce 1 102)
    (209, Token (THEN _)) -> Just (Reduce 1 102)
    (209, Token (ELSE _)) -> Just (Reduce 1 102)
    (209, Token (QVARSYM _)) -> Just (Reduce 1 102)
    (209, Token (BACKQUOTE _)) -> Just (Reduce 1 102)
    (209, Token (QCONSYM _)) -> Just (Reduce 1 102)
    (209, Token (INTEGER _)) -> Just (Reduce 1 102)
    (210, Token (WHERE _)) -> Just (Reduce 2 103)
    (210, Token (LBRACE _)) -> Just (Reduce 2 103)
    (210, Token (RBRACE _)) -> Just (Reduce 2 103)
    (210, Token (LPAREN _)) -> Just (Reduce 2 103)
    (210, Token (RPAREN _)) -> Just (Reduce 2 103)
    (210, Token (COMMA _)) -> Just (Reduce 2 103)
    (210, Token (SEMICOLON _)) -> Just (Reduce 2 103)
    (210, Token (EQUAL _)) -> Just (Reduce 2 103)
    (210, Token (DERIVING _)) -> Just (Reduce 2 103)
    (210, Token (DARROW _)) -> Just (Reduce 2 103)
    (210, Token (PIPE _)) -> Just (Reduce 2 103)
    (210, Token (COLON_COLON _)) -> Just (Reduce 2 103)
    (210, Token (MINUS _)) -> Just (Reduce 2 103)
    (210, Token (INFIXL _)) -> Just (Reduce 2 103)
    (210, Token (INFIXR _)) -> Just (Reduce 2 103)
    (210, Token (INFIX _)) -> Just (Reduce 2 103)
    (210, Token (RARROW _)) -> Just (Reduce 2 103)
    (210, Token (LBRACKET _)) -> Just (Reduce 2 103)
    (210, Token (RBRACKET _)) -> Just (Reduce 2 103)
    (210, Token (EXCL _)) -> Just (Reduce 2 103)
    (210, Token (QCONID _)) -> Just (Reduce 2 103)
    (210, Token (EXPORT _)) -> Just (Reduce 2 103)
    (210, Token (AS _)) -> Just (Reduce 2 103)
    (210, Token (QVARID _)) -> Just (Reduce 2 103)
    (210, Token (LARROW _)) -> Just (Reduce 2 103)
    (210, Token (THEN _)) -> Just (Reduce 2 103)
    (210, Token (ELSE _)) -> Just (Reduce 2 103)
    (210, Token (QVARSYM _)) -> Just (Reduce 2 103)
    (210, Token (BACKQUOTE _)) -> Just (Reduce 2 103)
    (210, Token (QCONSYM _)) -> Just (Reduce 2 103)
    (210, Token (INTEGER _)) -> Just (Reduce 2 103)
    (211, Token (WHERE _)) -> Just (Reduce 3 101)
    (211, Token (RBRACE _)) -> Just (Reduce 3 101)
    (211, Token (RPAREN _)) -> Just (Reduce 3 101)
    (211, Token (COMMA _)) -> Just (Reduce 3 101)
    (211, Token (SEMICOLON _)) -> Just (Reduce 3 101)
    (211, Token (EQUAL _)) -> Just (Reduce 3 101)
    (211, Token (PIPE _)) -> Just (Reduce 3 101)
    (211, Token (RBRACKET _)) -> Just (Reduce 3 101)
    (211, Token (LARROW _)) -> Just (Reduce 3 101)
    (211, Token (THEN _)) -> Just (Reduce 3 101)
    (211, Token (ELSE _)) -> Just (Reduce 3 101)
    (212, Token (RBRACE _)) -> Just (Reduce 2 120)
    (212, Token (SEMICOLON _)) -> Just (Reduce 2 120)
    (212, Token (DERIVING _)) -> Just (Reduce 2 120)
    (213, Token (QCONID _)) -> Just (Shift 214)
    (214, Token (RBRACE _)) -> Just (Reduce 1 134)
    (214, Token (RPAREN _)) -> Just (Reduce 1 134)
    (214, Token (COMMA _)) -> Just (Reduce 1 134)
    (214, Token (SEMICOLON _)) -> Just (Reduce 1 134)
    (215, Token (RPAREN _)) -> Just (Reduce 1 132)
    (215, Token (COMMA _)) -> Just (Shift 213)
    (216, Token (RPAREN _)) -> Just (Reduce 3 133)
    (217, Token (RBRACE _)) -> Just (Reduce 7 128)
    (217, Token (SEMICOLON _)) -> Just (Reduce 7 128)
    (217, Token (DERIVING _)) -> Just (Reduce 7 128)
    (218, Token (COLON_COLON _)) -> Just (Shift 129)
    (219, Token (RBRACE _)) -> Just (Shift 217)
    (220, Token (RBRACE _)) -> Just (Reduce 3 127)
    (220, Token (SEMICOLON _)) -> Just (Reduce 3 127)
    (220, Token (DERIVING _)) -> Just (Reduce 3 127)
    (221, Token (LBRACE _)) -> Just (Shift 67)
    (222, Token (RBRACE _)) -> Just (Reduce 2 66)
    (222, Token (SEMICOLON _)) -> Just (Reduce 2 66)
    (223, Token (LBRACE _)) -> Just (Shift 70)
    (224, Token (RBRACE _)) -> Just (Reduce 2 76)
    (224, Token (SEMICOLON _)) -> Just (Reduce 2 76)
    (225, Token (RPAREN _)) -> Just (Reduce 1 98)
    (225, Token (COMMA _)) -> Just (Shift 139)
    (226, Token (RPAREN _)) -> Just (Reduce 3 99)
    (227, Token (EXPORT _)) -> Just (Shift 339)
    (227, Token (AS _)) -> Just (Shift 340)
    (227, Token (QVARID _)) -> Just (Shift 341)
    (228, Token (EXPORT _)) -> Just (Shift 339)
    (228, Token (AS _)) -> Just (Shift 340)
    (228, Token (QVARID _)) -> Just (Shift 341)
    (229, Token (COLON_COLON _)) -> Just (Shift 124)
    (230, Token (COLON_COLON _)) -> Just (Shift 125)
    (231, Token (COLON_COLON _)) -> Just (Shift 126)
    (232, Token (RBRACE _)) -> Just (Reduce 6 135)
    (232, Token (SEMICOLON _)) -> Just (Reduce 6 135)
    (233, Token (RBRACE _)) -> Just (Reduce 7 136)
    (233, Token (SEMICOLON _)) -> Just (Reduce 7 136)
    (234, Token (RBRACE _)) -> Just (Reduce 6 137)
    (234, Token (SEMICOLON _)) -> Just (Reduce 6 137)
    (235, Token (EXPORT _)) -> Just (Shift 343)
    (235, Token (AS _)) -> Just (Shift 344)
    (235, Token (QVARID _)) -> Just (Shift 345)
    (235, Token (STRING _)) -> Just (Shift 342)
    (236, Token (STRING _)) -> Just (Shift 346)
    (237, Token (STRING _)) -> Just (Shift 342)
    (238, Token (LBRACE _)) -> Just (Shift 65)
    (239, Token (LBRACE _)) -> Just (Shift 65)
    (240, Token (RBRACE _)) -> Just (Reduce 5 62)
    (240, Token (SEMICOLON _)) -> Just (Reduce 5 62)
    (241, Token (RBRACE _)) -> Just (Reduce 5 64)
    (241, Token (SEMICOLON _)) -> Just (Reduce 5 64)
    (242, Token (RBRACE _)) -> Just (Reduce 1 60)
    (242, Token (SEMICOLON _)) -> Just (Reduce 1 60)
    (243, Token (WHERE _)) -> Just (Shift 238)
    (243, Token (RBRACE _)) -> Just (Reduce 3 61)
    (243, Token (SEMICOLON _)) -> Just (Reduce 3 61)
    (244, Token (WHERE _)) -> Just (Shift 239)
    (244, Token (RBRACE _)) -> Just (Reduce 3 63)
    (244, Token (SEMICOLON _)) -> Just (Reduce 3 63)
    (245, Token (LBRACE _)) -> Just (Shift 65)
    (246, Token (LBRACE _)) -> Just (Shift 65)
    (247, Token (LBRACE _)) -> Just (Shift 65)
    (248, Token (LBRACE _)) -> Just (Shift 65)
    (249, Token (LBRACE _)) -> Just (Shift 65)
    (250, Token (LBRACE _)) -> Just (Shift 65)
    (251, Token (RBRACE _)) -> Just (Reduce 3 57)
    (251, Token (COMMA _)) -> Just (Reduce 3 57)
    (251, Token (SEMICOLON _)) -> Just (Reduce 3 57)
    (251, Token (EQUAL _)) -> Just (Reduce 3 57)
    (251, Token (IN _)) -> Just (Reduce 3 57)
    (252, Token (RBRACE _)) -> Just (Shift 251)
    (253, Token (RBRACE _)) -> Just (Reduce 1 58)
    (253, Token (SEMICOLON _)) -> Just (Shift 66)
    (254, Token (RBRACE _)) -> Just (Reduce 3 59)
    (255, Token (RBRACE _)) -> Just (Reduce 5 87)
    (255, Token (SEMICOLON _)) -> Just (Reduce 5 87)
    (256, Token (RBRACE _)) -> Just (Reduce 3 86)
    (256, Token (SEMICOLON _)) -> Just (Reduce 3 86)
    (257, Token (COLON_COLON _)) -> Just (Shift 121)
    (258, Token (COMMA _)) -> Just (Reduce 0 205)
    (258, Token (MINUS _)) -> Just (Reduce 0 205)
    (258, Token (QCONID _)) -> Just (Reduce 0 205)
    (258, Token (EXPORT _)) -> Just (Reduce 0 205)
    (258, Token (AS _)) -> Just (Reduce 0 205)
    (258, Token (QVARID _)) -> Just (Reduce 0 205)
    (258, Token (QVARSYM _)) -> Just (Reduce 0 205)
    (258, Token (BACKQUOTE _)) -> Just (Reduce 0 205)
    (258, Token (QCONSYM _)) -> Just (Reduce 0 205)
    (258, Token (INTEGER _)) -> Just (Shift 292)
    (259, Token (MINUS _)) -> Just (Shift 295)
    (259, Token (QVARSYM _)) -> Just (Shift 388)
    (259, Token (BACKQUOTE _)) -> Just (Shift 331)
    (259, Token (QCONSYM _)) -> Just (Shift 334)
    (260, Token (RBRACE _)) -> Just (Reduce 3 88)
    (260, Token (SEMICOLON _)) -> Just (Reduce 3 88)
    (261, Token (LPAREN _)) -> Just (Reduce 1 175)
    (261, Token (RPAREN _)) -> Just (Reduce 1 175)
    (261, Token (EQUAL _)) -> Just (Reduce 1 175)
    (261, Token (PIPE _)) -> Just (Reduce 1 175)
    (261, Token (MINUS _)) -> Just (Reduce 1 175)
    (261, Token (RARROW _)) -> Just (Reduce 1 175)
    (261, Token (QCONID _)) -> Just (Reduce 1 175)
    (261, Token (EXPORT _)) -> Just (Reduce 1 175)
    (261, Token (AS _)) -> Just (Reduce 1 175)
    (261, Token (QVARID _)) -> Just (Reduce 1 175)
    (261, Token (QVARSYM _)) -> Just (Reduce 1 175)
    (261, Token (BACKQUOTE _)) -> Just (Reduce 1 175)
    (261, Token (QCONSYM _)) -> Just (Reduce 1 175)
    (262, Token (LPAREN _)) -> Just (Reduce 3 177)
    (262, Token (RPAREN _)) -> Just (Reduce 3 177)
    (262, Token (EQUAL _)) -> Just (Reduce 3 177)
    (262, Token (PIPE _)) -> Just (Reduce 3 177)
    (262, Token (MINUS _)) -> Just (Reduce 3 177)
    (262, Token (RARROW _)) -> Just (Reduce 3 177)
    (262, Token (QCONID _)) -> Just (Reduce 3 177)
    (262, Token (EXPORT _)) -> Just (Reduce 3 177)
    (262, Token (AS _)) -> Just (Reduce 3 177)
    (262, Token (QVARID _)) -> Just (Reduce 3 177)
    (262, Token (QVARSYM _)) -> Just (Reduce 3 177)
    (262, Token (BACKQUOTE _)) -> Just (Reduce 3 177)
    (262, Token (QCONSYM _)) -> Just (Reduce 3 177)
    (263, Token (LPAREN _)) -> Just (Reduce 2 176)
    (263, Token (RPAREN _)) -> Just (Reduce 2 176)
    (263, Token (EQUAL _)) -> Just (Reduce 2 176)
    (263, Token (PIPE _)) -> Just (Reduce 2 176)
    (263, Token (MINUS _)) -> Just (Reduce 2 176)
    (263, Token (RARROW _)) -> Just (Reduce 2 176)
    (263, Token (QCONID _)) -> Just (Reduce 2 176)
    (263, Token (EXPORT _)) -> Just (Reduce 2 176)
    (263, Token (AS _)) -> Just (Reduce 2 176)
    (263, Token (QVARID _)) -> Just (Reduce 2 176)
    (263, Token (QVARSYM _)) -> Just (Reduce 2 176)
    (263, Token (BACKQUOTE _)) -> Just (Reduce 2 176)
    (263, Token (QCONSYM _)) -> Just (Reduce 2 176)
    (264, Token (LPAREN _)) -> Just (Reduce 3 178)
    (264, Token (RPAREN _)) -> Just (Reduce 3 178)
    (264, Token (EQUAL _)) -> Just (Reduce 3 178)
    (264, Token (PIPE _)) -> Just (Reduce 3 178)
    (264, Token (MINUS _)) -> Just (Reduce 3 178)
    (264, Token (RARROW _)) -> Just (Reduce 3 178)
    (264, Token (QCONID _)) -> Just (Reduce 3 178)
    (264, Token (EXPORT _)) -> Just (Reduce 3 178)
    (264, Token (AS _)) -> Just (Reduce 3 178)
    (264, Token (QVARID _)) -> Just (Reduce 3 178)
    (264, Token (QVARSYM _)) -> Just (Reduce 3 178)
    (264, Token (BACKQUOTE _)) -> Just (Reduce 3 178)
    (264, Token (QCONSYM _)) -> Just (Reduce 3 178)
    (265, Token (WHERE _)) -> Just (Reduce 1 153)
    (265, Token (RBRACE _)) -> Just (Reduce 1 153)
    (265, Token (RPAREN _)) -> Just (Reduce 1 153)
    (265, Token (COMMA _)) -> Just (Reduce 1 153)
    (265, Token (SEMICOLON _)) -> Just (Reduce 1 153)
    (265, Token (EQUAL _)) -> Just (Reduce 1 153)
    (265, Token (PIPE _)) -> Just (Reduce 1 153)
    (265, Token (LARROW _)) -> Just (Reduce 1 153)
    (265, Token (THEN _)) -> Just (Reduce 1 153)
    (265, Token (ELSE _)) -> Just (Reduce 1 153)
    (266, Token (WHERE _)) -> Just (Reduce 3 146)
    (266, Token (RBRACE _)) -> Just (Reduce 3 146)
    (266, Token (SEMICOLON _)) -> Just (Reduce 3 146)
    (266, Token (PIPE _)) -> Just (Shift 54)
    (267, Token (WHERE _)) -> Just (Reduce 5 147)
    (267, Token (RBRACE _)) -> Just (Reduce 5 147)
    (267, Token (SEMICOLON _)) -> Just (Reduce 5 147)
    (268, Token (EQUAL _)) -> Just (Shift 48)
    (269, Token (RBRACE _)) -> Just (Reduce 3 67)
    (269, Token (SEMICOLON _)) -> Just (Reduce 3 67)
    (270, Token (RBRACE _)) -> Just (Shift 269)
    (271, Token (RBRACE _)) -> Just (Reduce 3 69)
    (272, Token (RBRACE _)) -> Just (Reduce 1 68)
    (272, Token (SEMICOLON _)) -> Just (Shift 68)
    (273, Token (RBRACE _)) -> Just (Reduce 5 72)
    (273, Token (SEMICOLON _)) -> Just (Reduce 5 72)
    (274, Token (RBRACE _)) -> Just (Reduce 5 74)
    (274, Token (SEMICOLON _)) -> Just (Reduce 5 74)
    (275, Token (RBRACE _)) -> Just (Reduce 1 70)
    (275, Token (SEMICOLON _)) -> Just (Reduce 1 70)
    (276, Token (WHERE _)) -> Just (Shift 245)
    (276, Token (RBRACE _)) -> Just (Reduce 3 71)
    (276, Token (SEMICOLON _)) -> Just (Reduce 3 71)
    (277, Token (WHERE _)) -> Just (Shift 246)
    (277, Token (RBRACE _)) -> Just (Reduce 3 73)
    (277, Token (SEMICOLON _)) -> Just (Reduce 3 73)
    (278, Token (RBRACE _)) -> Just (Reduce 3 77)
    (278, Token (SEMICOLON _)) -> Just (Reduce 3 77)
    (279, Token (RBRACE _)) -> Just (Shift 278)
    (280, Token (RBRACE _)) -> Just (Reduce 3 79)
    (281, Token (RBRACE _)) -> Just (Reduce 1 78)
    (281, Token (SEMICOLON _)) -> Just (Shift 71)
    (282, Token (RBRACE _)) -> Just (Reduce 5 82)
    (282, Token (SEMICOLON _)) -> Just (Reduce 5 82)
    (283, Token (RBRACE _)) -> Just (Reduce 5 84)
    (283, Token (SEMICOLON _)) -> Just (Reduce 5 84)
    (284, Token (WHERE _)) -> Just (Shift 247)
    (284, Token (RBRACE _)) -> Just (Reduce 3 81)
    (284, Token (SEMICOLON _)) -> Just (Reduce 3 81)
    (285, Token (WHERE _)) -> Just (Shift 248)
    (285, Token (RBRACE _)) -> Just (Reduce 3 83)
    (285, Token (SEMICOLON _)) -> Just (Reduce 3 83)
    (286, Token (COMMA _)) -> Just (Shift 81)
    (286, Token (COLON_COLON _)) -> Just (Reduce 1 93)
    (287, Token (LPAREN _)) -> Just (Reduce 1 179)
    (287, Token (COMMA _)) -> Just (Shift 81)
    (287, Token (EQUAL _)) -> Just (Reduce 1 179)
    (287, Token (PIPE _)) -> Just (Reduce 1 179)
    (287, Token (COLON_COLON _)) -> Just (Reduce 1 93)
    (287, Token (MINUS _)) -> Just (Reduce 1 179)
    (287, Token (QCONID _)) -> Just (Reduce 1 179)
    (287, Token (EXPORT _)) -> Just (Reduce 1 179)
    (287, Token (AS _)) -> Just (Reduce 1 179)
    (287, Token (QVARID _)) -> Just (Reduce 1 179)
    (287, Token (QVARSYM _)) -> Just (Reduce 1 179)
    (287, Token (BACKQUOTE _)) -> Just (Reduce 1 179)
    (287, Token (QCONSYM _)) -> Just (Reduce 1 179)
    (288, Token (COLON_COLON _)) -> Just (Reduce 3 94)
    (289, Token (COMMA _)) -> Just (Reduce 1 95)
    (289, Token (MINUS _)) -> Just (Reduce 1 95)
    (289, Token (QCONID _)) -> Just (Reduce 1 95)
    (289, Token (EXPORT _)) -> Just (Reduce 1 95)
    (289, Token (AS _)) -> Just (Reduce 1 95)
    (289, Token (QVARID _)) -> Just (Reduce 1 95)
    (289, Token (QVARSYM _)) -> Just (Reduce 1 95)
    (289, Token (BACKQUOTE _)) -> Just (Reduce 1 95)
    (289, Token (QCONSYM _)) -> Just (Reduce 1 95)
    (289, Token (INTEGER _)) -> Just (Reduce 1 95)
    (290, Token (COMMA _)) -> Just (Reduce 1 96)
    (290, Token (MINUS _)) -> Just (Reduce 1 96)
    (290, Token (QCONID _)) -> Just (Reduce 1 96)
    (290, Token (EXPORT _)) -> Just (Reduce 1 96)
    (290, Token (AS _)) -> Just (Reduce 1 96)
    (290, Token (QVARID _)) -> Just (Reduce 1 96)
    (290, Token (QVARSYM _)) -> Just (Reduce 1 96)
    (290, Token (BACKQUOTE _)) -> Just (Reduce 1 96)
    (290, Token (QCONSYM _)) -> Just (Reduce 1 96)
    (290, Token (INTEGER _)) -> Just (Reduce 1 96)
    (291, Token (COMMA _)) -> Just (Reduce 1 97)
    (291, Token (MINUS _)) -> Just (Reduce 1 97)
    (291, Token (QCONID _)) -> Just (Reduce 1 97)
    (291, Token (EXPORT _)) -> Just (Reduce 1 97)
    (291, Token (AS _)) -> Just (Reduce 1 97)
    (291, Token (QVARID _)) -> Just (Reduce 1 97)
    (291, Token (QVARSYM _)) -> Just (Reduce 1 97)
    (291, Token (BACKQUOTE _)) -> Just (Reduce 1 97)
    (291, Token (QCONSYM _)) -> Just (Reduce 1 97)
    (291, Token (INTEGER _)) -> Just (Reduce 1 97)
    (292, Token (COMMA _)) -> Just (Reduce 1 206)
    (292, Token (MINUS _)) -> Just (Reduce 1 206)
    (292, Token (QCONID _)) -> Just (Reduce 1 206)
    (292, Token (EXPORT _)) -> Just (Reduce 1 206)
    (292, Token (AS _)) -> Just (Reduce 1 206)
    (292, Token (QVARID _)) -> Just (Reduce 1 206)
    (292, Token (QVARSYM _)) -> Just (Reduce 1 206)
    (292, Token (BACKQUOTE _)) -> Just (Reduce 1 206)
    (292, Token (QCONSYM _)) -> Just (Reduce 1 206)
    (293, Token (MINUS _)) -> Just (Shift 295)
    (293, Token (QVARSYM _)) -> Just (Shift 388)
    (293, Token (BACKQUOTE _)) -> Just (Shift 331)
    (293, Token (QCONSYM _)) -> Just (Shift 334)
    (294, Token (MINUS _)) -> Just (Shift 295)
    (294, Token (QVARSYM _)) -> Just (Shift 388)
    (294, Token (BACKQUOTE _)) -> Just (Shift 331)
    (294, Token (QCONSYM _)) -> Just (Shift 334)
    (295, Token (RBRACE _)) -> Just (Reduce 1 89)
    (295, Token (COMMA _)) -> Just (Shift 293)
    (295, Token (SEMICOLON _)) -> Just (Reduce 1 89)
    (296, Token (RBRACE _)) -> Just (Reduce 3 91)
    (296, Token (SEMICOLON _)) -> Just (Reduce 3 91)
    (297, Token (RBRACE _)) -> Just (Reduce 3 92)
    (297, Token (SEMICOLON _)) -> Just (Reduce 3 92)
    (298, Token (RBRACE _)) -> Just (Reduce 1 90)
    (298, Token (COMMA _)) -> Just (Shift 294)
    (298, Token (SEMICOLON _)) -> Just (Reduce 1 90)
    (299, Token (RBRACE _)) -> Just (Reduce 1 195)
    (299, Token (LPAREN _)) -> Just (Reduce 1 195)
    (299, Token (COMMA _)) -> Just (Reduce 1 195)
    (299, Token (SEMICOLON _)) -> Just (Reduce 1 195)
    (299, Token (MINUS _)) -> Just (Reduce 1 195)
    (299, Token (QCONID _)) -> Just (Reduce 1 195)
    (299, Token (EXPORT _)) -> Just (Reduce 1 195)
    (299, Token (AS _)) -> Just (Reduce 1 195)
    (299, Token (QVARID _)) -> Just (Reduce 1 195)
    (299, Token (QVARSYM _)) -> Just (Reduce 1 195)
    (299, Token (BACKQUOTE _)) -> Just (Reduce 1 195)
    (299, Token (QCONSYM _)) -> Just (Reduce 1 195)
    (300, Token (RBRACE _)) -> Just (Reduce 1 194)
    (300, Token (LPAREN _)) -> Just (Reduce 1 194)
    (300, Token (COMMA _)) -> Just (Reduce 1 194)
    (300, Token (SEMICOLON _)) -> Just (Reduce 1 194)
    (300, Token (MINUS _)) -> Just (Reduce 1 194)
    (300, Token (QCONID _)) -> Just (Reduce 1 194)
    (300, Token (EXPORT _)) -> Just (Reduce 1 194)
    (300, Token (AS _)) -> Just (Reduce 1 194)
    (300, Token (QVARID _)) -> Just (Reduce 1 194)
    (300, Token (QVARSYM _)) -> Just (Reduce 1 194)
    (300, Token (BACKQUOTE _)) -> Just (Reduce 1 194)
    (300, Token (QCONSYM _)) -> Just (Reduce 1 194)
    (301, Token (WHERE _)) -> Just (Reduce 3 108)
    (301, Token (LBRACE _)) -> Just (Reduce 3 108)
    (301, Token (RBRACE _)) -> Just (Reduce 3 108)
    (301, Token (LPAREN _)) -> Just (Reduce 3 108)
    (301, Token (RPAREN _)) -> Just (Reduce 3 108)
    (301, Token (COMMA _)) -> Just (Reduce 3 108)
    (301, Token (SEMICOLON _)) -> Just (Reduce 3 108)
    (301, Token (EQUAL _)) -> Just (Reduce 3 108)
    (301, Token (DERIVING _)) -> Just (Reduce 3 108)
    (301, Token (DARROW _)) -> Just (Reduce 3 108)
    (301, Token (PIPE _)) -> Just (Reduce 3 108)
    (301, Token (COLON_COLON _)) -> Just (Reduce 3 108)
    (301, Token (MINUS _)) -> Just (Reduce 3 108)
    (301, Token (INFIXL _)) -> Just (Reduce 3 108)
    (301, Token (INFIXR _)) -> Just (Reduce 3 108)
    (301, Token (INFIX _)) -> Just (Reduce 3 108)
    (301, Token (RARROW _)) -> Just (Reduce 3 108)
    (301, Token (LBRACKET _)) -> Just (Reduce 3 108)
    (301, Token (RBRACKET _)) -> Just (Reduce 3 108)
    (301, Token (EXCL _)) -> Just (Reduce 3 108)
    (301, Token (QCONID _)) -> Just (Reduce 3 108)
    (301, Token (EXPORT _)) -> Just (Reduce 3 108)
    (301, Token (AS _)) -> Just (Reduce 3 108)
    (301, Token (QVARID _)) -> Just (Reduce 3 108)
    (301, Token (LARROW _)) -> Just (Reduce 3 108)
    (301, Token (THEN _)) -> Just (Reduce 3 108)
    (301, Token (ELSE _)) -> Just (Reduce 3 108)
    (301, Token (QVARSYM _)) -> Just (Reduce 3 108)
    (301, Token (BACKQUOTE _)) -> Just (Reduce 3 108)
    (301, Token (QCONSYM _)) -> Just (Reduce 3 108)
    (301, Token (INTEGER _)) -> Just (Reduce 3 108)
    (302, Token (WHERE _)) -> Just (Reduce 3 106)
    (302, Token (LBRACE _)) -> Just (Reduce 3 106)
    (302, Token (RBRACE _)) -> Just (Reduce 3 106)
    (302, Token (LPAREN _)) -> Just (Reduce 3 106)
    (302, Token (RPAREN _)) -> Just (Reduce 3 106)
    (302, Token (COMMA _)) -> Just (Reduce 3 106)
    (302, Token (SEMICOLON _)) -> Just (Reduce 3 106)
    (302, Token (EQUAL _)) -> Just (Reduce 3 106)
    (302, Token (DERIVING _)) -> Just (Reduce 3 106)
    (302, Token (DARROW _)) -> Just (Reduce 3 106)
    (302, Token (PIPE _)) -> Just (Reduce 3 106)
    (302, Token (COLON_COLON _)) -> Just (Reduce 3 106)
    (302, Token (MINUS _)) -> Just (Reduce 3 106)
    (302, Token (INFIXL _)) -> Just (Reduce 3 106)
    (302, Token (INFIXR _)) -> Just (Reduce 3 106)
    (302, Token (INFIX _)) -> Just (Reduce 3 106)
    (302, Token (RARROW _)) -> Just (Reduce 3 106)
    (302, Token (LBRACKET _)) -> Just (Reduce 3 106)
    (302, Token (RBRACKET _)) -> Just (Reduce 3 106)
    (302, Token (EXCL _)) -> Just (Reduce 3 106)
    (302, Token (QCONID _)) -> Just (Reduce 3 106)
    (302, Token (EXPORT _)) -> Just (Reduce 3 106)
    (302, Token (AS _)) -> Just (Reduce 3 106)
    (302, Token (QVARID _)) -> Just (Reduce 3 106)
    (302, Token (LARROW _)) -> Just (Reduce 3 106)
    (302, Token (THEN _)) -> Just (Reduce 3 106)
    (302, Token (ELSE _)) -> Just (Reduce 3 106)
    (302, Token (QVARSYM _)) -> Just (Reduce 3 106)
    (302, Token (BACKQUOTE _)) -> Just (Reduce 3 106)
    (302, Token (QCONSYM _)) -> Just (Reduce 3 106)
    (302, Token (INTEGER _)) -> Just (Reduce 3 106)
    (303, Token (WHERE _)) -> Just (Reduce 3 107)
    (303, Token (LBRACE _)) -> Just (Reduce 3 107)
    (303, Token (RBRACE _)) -> Just (Reduce 3 107)
    (303, Token (LPAREN _)) -> Just (Reduce 3 107)
    (303, Token (RPAREN _)) -> Just (Reduce 3 107)
    (303, Token (COMMA _)) -> Just (Reduce 3 107)
    (303, Token (SEMICOLON _)) -> Just (Reduce 3 107)
    (303, Token (EQUAL _)) -> Just (Reduce 3 107)
    (303, Token (DERIVING _)) -> Just (Reduce 3 107)
    (303, Token (DARROW _)) -> Just (Reduce 3 107)
    (303, Token (PIPE _)) -> Just (Reduce 3 107)
    (303, Token (COLON_COLON _)) -> Just (Reduce 3 107)
    (303, Token (MINUS _)) -> Just (Reduce 3 107)
    (303, Token (INFIXL _)) -> Just (Reduce 3 107)
    (303, Token (INFIXR _)) -> Just (Reduce 3 107)
    (303, Token (INFIX _)) -> Just (Reduce 3 107)
    (303, Token (RARROW _)) -> Just (Reduce 3 107)
    (303, Token (LBRACKET _)) -> Just (Reduce 3 107)
    (303, Token (RBRACKET _)) -> Just (Reduce 3 107)
    (303, Token (EXCL _)) -> Just (Reduce 3 107)
    (303, Token (QCONID _)) -> Just (Reduce 3 107)
    (303, Token (EXPORT _)) -> Just (Reduce 3 107)
    (303, Token (AS _)) -> Just (Reduce 3 107)
    (303, Token (QVARID _)) -> Just (Reduce 3 107)
    (303, Token (LARROW _)) -> Just (Reduce 3 107)
    (303, Token (THEN _)) -> Just (Reduce 3 107)
    (303, Token (ELSE _)) -> Just (Reduce 3 107)
    (303, Token (QVARSYM _)) -> Just (Reduce 3 107)
    (303, Token (BACKQUOTE _)) -> Just (Reduce 3 107)
    (303, Token (QCONSYM _)) -> Just (Reduce 3 107)
    (303, Token (INTEGER _)) -> Just (Reduce 3 107)
    (304, Token (RPAREN _)) -> Just (Shift 301)
    (304, Token (COMMA _)) -> Just (Shift 140)
    (305, Token (RBRACKET _)) -> Just (Shift 303)
    (306, Token (WHERE _)) -> Just (Reduce 2 109)
    (306, Token (LBRACE _)) -> Just (Reduce 2 109)
    (306, Token (RBRACE _)) -> Just (Reduce 2 109)
    (306, Token (LPAREN _)) -> Just (Reduce 2 109)
    (306, Token (RPAREN _)) -> Just (Reduce 2 109)
    (306, Token (COMMA _)) -> Just (Reduce 2 109)
    (306, Token (SEMICOLON _)) -> Just (Reduce 2 109)
    (306, Token (EQUAL _)) -> Just (Reduce 2 109)
    (306, Token (DERIVING _)) -> Just (Reduce 2 109)
    (306, Token (DARROW _)) -> Just (Reduce 2 109)
    (306, Token (PIPE _)) -> Just (Reduce 2 109)
    (306, Token (COLON_COLON _)) -> Just (Reduce 2 109)
    (306, Token (MINUS _)) -> Just (Reduce 2 109)
    (306, Token (INFIXL _)) -> Just (Reduce 2 109)
    (306, Token (INFIXR _)) -> Just (Reduce 2 109)
    (306, Token (INFIX _)) -> Just (Reduce 2 109)
    (306, Token (RARROW _)) -> Just (Reduce 2 109)
    (306, Token (LBRACKET _)) -> Just (Reduce 2 109)
    (306, Token (RBRACKET _)) -> Just (Reduce 2 109)
    (306, Token (EXCL _)) -> Just (Reduce 2 109)
    (306, Token (QCONID _)) -> Just (Reduce 2 109)
    (306, Token (EXPORT _)) -> Just (Reduce 2 109)
    (306, Token (AS _)) -> Just (Reduce 2 109)
    (306, Token (QVARID _)) -> Just (Reduce 2 109)
    (306, Token (LARROW _)) -> Just (Reduce 2 109)
    (306, Token (THEN _)) -> Just (Reduce 2 109)
    (306, Token (ELSE _)) -> Just (Reduce 2 109)
    (306, Token (QVARSYM _)) -> Just (Reduce 2 109)
    (306, Token (BACKQUOTE _)) -> Just (Reduce 2 109)
    (306, Token (QCONSYM _)) -> Just (Reduce 2 109)
    (306, Token (INTEGER _)) -> Just (Reduce 2 109)
    (307, Token (WHERE _)) -> Just (Reduce 1 104)
    (307, Token (LBRACE _)) -> Just (Reduce 1 104)
    (307, Token (RBRACE _)) -> Just (Reduce 1 104)
    (307, Token (LPAREN _)) -> Just (Reduce 1 104)
    (307, Token (RPAREN _)) -> Just (Reduce 1 104)
    (307, Token (COMMA _)) -> Just (Reduce 1 104)
    (307, Token (SEMICOLON _)) -> Just (Reduce 1 104)
    (307, Token (EQUAL _)) -> Just (Reduce 1 104)
    (307, Token (DERIVING _)) -> Just (Reduce 1 104)
    (307, Token (DARROW _)) -> Just (Reduce 1 104)
    (307, Token (PIPE _)) -> Just (Reduce 1 104)
    (307, Token (COLON_COLON _)) -> Just (Reduce 1 104)
    (307, Token (MINUS _)) -> Just (Reduce 1 104)
    (307, Token (INFIXL _)) -> Just (Reduce 1 104)
    (307, Token (INFIXR _)) -> Just (Reduce 1 104)
    (307, Token (INFIX _)) -> Just (Reduce 1 104)
    (307, Token (RARROW _)) -> Just (Reduce 1 104)
    (307, Token (LBRACKET _)) -> Just (Reduce 1 104)
    (307, Token (RBRACKET _)) -> Just (Reduce 1 104)
    (307, Token (EXCL _)) -> Just (Reduce 1 104)
    (307, Token (QCONID _)) -> Just (Reduce 1 104)
    (307, Token (EXPORT _)) -> Just (Reduce 1 104)
    (307, Token (AS _)) -> Just (Reduce 1 104)
    (307, Token (QVARID _)) -> Just (Reduce 1 104)
    (307, Token (LARROW _)) -> Just (Reduce 1 104)
    (307, Token (THEN _)) -> Just (Reduce 1 104)
    (307, Token (ELSE _)) -> Just (Reduce 1 104)
    (307, Token (QVARSYM _)) -> Just (Reduce 1 104)
    (307, Token (BACKQUOTE _)) -> Just (Reduce 1 104)
    (307, Token (QCONSYM _)) -> Just (Reduce 1 104)
    (307, Token (INTEGER _)) -> Just (Reduce 1 104)
    (308, Token (WHERE _)) -> Just (Reduce 1 105)
    (308, Token (LBRACE _)) -> Just (Reduce 1 105)
    (308, Token (RBRACE _)) -> Just (Reduce 1 105)
    (308, Token (LPAREN _)) -> Just (Reduce 1 105)
    (308, Token (RPAREN _)) -> Just (Reduce 1 105)
    (308, Token (COMMA _)) -> Just (Reduce 1 105)
    (308, Token (SEMICOLON _)) -> Just (Reduce 1 105)
    (308, Token (EQUAL _)) -> Just (Reduce 1 105)
    (308, Token (DERIVING _)) -> Just (Reduce 1 105)
    (308, Token (DARROW _)) -> Just (Reduce 1 105)
    (308, Token (PIPE _)) -> Just (Reduce 1 105)
    (308, Token (COLON_COLON _)) -> Just (Reduce 1 105)
    (308, Token (MINUS _)) -> Just (Reduce 1 105)
    (308, Token (INFIXL _)) -> Just (Reduce 1 105)
    (308, Token (INFIXR _)) -> Just (Reduce 1 105)
    (308, Token (INFIX _)) -> Just (Reduce 1 105)
    (308, Token (RARROW _)) -> Just (Reduce 1 105)
    (308, Token (LBRACKET _)) -> Just (Reduce 1 105)
    (308, Token (RBRACKET _)) -> Just (Reduce 1 105)
    (308, Token (EXCL _)) -> Just (Reduce 1 105)
    (308, Token (QCONID _)) -> Just (Reduce 1 105)
    (308, Token (EXPORT _)) -> Just (Reduce 1 105)
    (308, Token (AS _)) -> Just (Reduce 1 105)
    (308, Token (QVARID _)) -> Just (Reduce 1 105)
    (308, Token (LARROW _)) -> Just (Reduce 1 105)
    (308, Token (THEN _)) -> Just (Reduce 1 105)
    (308, Token (ELSE _)) -> Just (Reduce 1 105)
    (308, Token (QVARSYM _)) -> Just (Reduce 1 105)
    (308, Token (BACKQUOTE _)) -> Just (Reduce 1 105)
    (308, Token (QCONSYM _)) -> Just (Reduce 1 105)
    (308, Token (INTEGER _)) -> Just (Reduce 1 105)
    (309, Token (RPAREN _)) -> Just (Shift 302)
    (310, Token (WHERE _)) -> Just (Reduce 2 113)
    (310, Token (LBRACE _)) -> Just (Reduce 2 113)
    (310, Token (RBRACE _)) -> Just (Reduce 2 113)
    (310, Token (LPAREN _)) -> Just (Reduce 2 113)
    (310, Token (RPAREN _)) -> Just (Reduce 2 113)
    (310, Token (COMMA _)) -> Just (Reduce 2 113)
    (310, Token (SEMICOLON _)) -> Just (Reduce 2 113)
    (310, Token (EQUAL _)) -> Just (Reduce 2 113)
    (310, Token (DERIVING _)) -> Just (Reduce 2 113)
    (310, Token (DARROW _)) -> Just (Reduce 2 113)
    (310, Token (PIPE _)) -> Just (Reduce 2 113)
    (310, Token (COLON_COLON _)) -> Just (Reduce 2 113)
    (310, Token (MINUS _)) -> Just (Reduce 2 113)
    (310, Token (INFIXL _)) -> Just (Reduce 2 113)
    (310, Token (INFIXR _)) -> Just (Reduce 2 113)
    (310, Token (INFIX _)) -> Just (Reduce 2 113)
    (310, Token (RARROW _)) -> Just (Reduce 2 113)
    (310, Token (LBRACKET _)) -> Just (Reduce 2 113)
    (310, Token (RBRACKET _)) -> Just (Reduce 2 113)
    (310, Token (EXCL _)) -> Just (Reduce 2 113)
    (310, Token (QCONID _)) -> Just (Reduce 2 113)
    (310, Token (EXPORT _)) -> Just (Reduce 2 113)
    (310, Token (AS _)) -> Just (Reduce 2 113)
    (310, Token (QVARID _)) -> Just (Reduce 2 113)
    (310, Token (LARROW _)) -> Just (Reduce 2 113)
    (310, Token (THEN _)) -> Just (Reduce 2 113)
    (310, Token (ELSE _)) -> Just (Reduce 2 113)
    (310, Token (QVARSYM _)) -> Just (Reduce 2 113)
    (310, Token (BACKQUOTE _)) -> Just (Reduce 2 113)
    (310, Token (QCONSYM _)) -> Just (Reduce 2 113)
    (310, Token (INTEGER _)) -> Just (Reduce 2 113)
    (311, Token (WHERE _)) -> Just (Reduce 3 115)
    (311, Token (LBRACE _)) -> Just (Reduce 3 115)
    (311, Token (RBRACE _)) -> Just (Reduce 3 115)
    (311, Token (LPAREN _)) -> Just (Reduce 3 115)
    (311, Token (RPAREN _)) -> Just (Reduce 3 115)
    (311, Token (COMMA _)) -> Just (Reduce 3 115)
    (311, Token (SEMICOLON _)) -> Just (Reduce 3 115)
    (311, Token (EQUAL _)) -> Just (Reduce 3 115)
    (311, Token (DERIVING _)) -> Just (Reduce 3 115)
    (311, Token (DARROW _)) -> Just (Reduce 3 115)
    (311, Token (PIPE _)) -> Just (Reduce 3 115)
    (311, Token (COLON_COLON _)) -> Just (Reduce 3 115)
    (311, Token (MINUS _)) -> Just (Reduce 3 115)
    (311, Token (INFIXL _)) -> Just (Reduce 3 115)
    (311, Token (INFIXR _)) -> Just (Reduce 3 115)
    (311, Token (INFIX _)) -> Just (Reduce 3 115)
    (311, Token (RARROW _)) -> Just (Reduce 3 115)
    (311, Token (LBRACKET _)) -> Just (Reduce 3 115)
    (311, Token (RBRACKET _)) -> Just (Reduce 3 115)
    (311, Token (EXCL _)) -> Just (Reduce 3 115)
    (311, Token (QCONID _)) -> Just (Reduce 3 115)
    (311, Token (EXPORT _)) -> Just (Reduce 3 115)
    (311, Token (AS _)) -> Just (Reduce 3 115)
    (311, Token (QVARID _)) -> Just (Reduce 3 115)
    (311, Token (LARROW _)) -> Just (Reduce 3 115)
    (311, Token (THEN _)) -> Just (Reduce 3 115)
    (311, Token (ELSE _)) -> Just (Reduce 3 115)
    (311, Token (QVARSYM _)) -> Just (Reduce 3 115)
    (311, Token (BACKQUOTE _)) -> Just (Reduce 3 115)
    (311, Token (QCONSYM _)) -> Just (Reduce 3 115)
    (311, Token (INTEGER _)) -> Just (Reduce 3 115)
    (312, Token (WHERE _)) -> Just (Reduce 3 116)
    (312, Token (LBRACE _)) -> Just (Reduce 3 116)
    (312, Token (RBRACE _)) -> Just (Reduce 3 116)
    (312, Token (LPAREN _)) -> Just (Reduce 3 116)
    (312, Token (RPAREN _)) -> Just (Reduce 3 116)
    (312, Token (COMMA _)) -> Just (Reduce 3 116)
    (312, Token (SEMICOLON _)) -> Just (Reduce 3 116)
    (312, Token (EQUAL _)) -> Just (Reduce 3 116)
    (312, Token (DERIVING _)) -> Just (Reduce 3 116)
    (312, Token (DARROW _)) -> Just (Reduce 3 116)
    (312, Token (PIPE _)) -> Just (Reduce 3 116)
    (312, Token (COLON_COLON _)) -> Just (Reduce 3 116)
    (312, Token (MINUS _)) -> Just (Reduce 3 116)
    (312, Token (INFIXL _)) -> Just (Reduce 3 116)
    (312, Token (INFIXR _)) -> Just (Reduce 3 116)
    (312, Token (INFIX _)) -> Just (Reduce 3 116)
    (312, Token (RARROW _)) -> Just (Reduce 3 116)
    (312, Token (LBRACKET _)) -> Just (Reduce 3 116)
    (312, Token (RBRACKET _)) -> Just (Reduce 3 116)
    (312, Token (EXCL _)) -> Just (Reduce 3 116)
    (312, Token (QCONID _)) -> Just (Reduce 3 116)
    (312, Token (EXPORT _)) -> Just (Reduce 3 116)
    (312, Token (AS _)) -> Just (Reduce 3 116)
    (312, Token (QVARID _)) -> Just (Reduce 3 116)
    (312, Token (LARROW _)) -> Just (Reduce 3 116)
    (312, Token (THEN _)) -> Just (Reduce 3 116)
    (312, Token (ELSE _)) -> Just (Reduce 3 116)
    (312, Token (QVARSYM _)) -> Just (Reduce 3 116)
    (312, Token (BACKQUOTE _)) -> Just (Reduce 3 116)
    (312, Token (QCONSYM _)) -> Just (Reduce 3 116)
    (312, Token (INTEGER _)) -> Just (Reduce 3 116)
    (313, Token (RPAREN _)) -> Just (Shift 311)
    (314, Token (WHERE _)) -> Just (Reduce 2 114)
    (314, Token (LBRACE _)) -> Just (Reduce 2 114)
    (314, Token (RBRACE _)) -> Just (Reduce 2 114)
    (314, Token (LPAREN _)) -> Just (Reduce 2 114)
    (314, Token (RPAREN _)) -> Just (Reduce 2 114)
    (314, Token (COMMA _)) -> Just (Reduce 2 114)
    (314, Token (SEMICOLON _)) -> Just (Reduce 2 114)
    (314, Token (EQUAL _)) -> Just (Reduce 2 114)
    (314, Token (DERIVING _)) -> Just (Reduce 2 114)
    (314, Token (DARROW _)) -> Just (Reduce 2 114)
    (314, Token (PIPE _)) -> Just (Reduce 2 114)
    (314, Token (COLON_COLON _)) -> Just (Reduce 2 114)
    (314, Token (MINUS _)) -> Just (Reduce 2 114)
    (314, Token (INFIXL _)) -> Just (Reduce 2 114)
    (314, Token (INFIXR _)) -> Just (Reduce 2 114)
    (314, Token (INFIX _)) -> Just (Reduce 2 114)
    (314, Token (RARROW _)) -> Just (Reduce 2 114)
    (314, Token (LBRACKET _)) -> Just (Reduce 2 114)
    (314, Token (RBRACKET _)) -> Just (Reduce 2 114)
    (314, Token (EXCL _)) -> Just (Reduce 2 114)
    (314, Token (QCONID _)) -> Just (Reduce 2 114)
    (314, Token (EXPORT _)) -> Just (Reduce 2 114)
    (314, Token (AS _)) -> Just (Reduce 2 114)
    (314, Token (QVARID _)) -> Just (Reduce 2 114)
    (314, Token (LARROW _)) -> Just (Reduce 2 114)
    (314, Token (THEN _)) -> Just (Reduce 2 114)
    (314, Token (ELSE _)) -> Just (Reduce 2 114)
    (314, Token (QVARSYM _)) -> Just (Reduce 2 114)
    (314, Token (BACKQUOTE _)) -> Just (Reduce 2 114)
    (314, Token (QCONSYM _)) -> Just (Reduce 2 114)
    (314, Token (INTEGER _)) -> Just (Reduce 2 114)
    (315, Token (WHERE _)) -> Just (Reduce 1 112)
    (315, Token (LBRACE _)) -> Just (Reduce 1 112)
    (315, Token (RBRACE _)) -> Just (Reduce 1 112)
    (315, Token (LPAREN _)) -> Just (Reduce 1 112)
    (315, Token (RPAREN _)) -> Just (Reduce 1 112)
    (315, Token (COMMA _)) -> Just (Reduce 1 112)
    (315, Token (SEMICOLON _)) -> Just (Reduce 1 112)
    (315, Token (EQUAL _)) -> Just (Reduce 1 112)
    (315, Token (DERIVING _)) -> Just (Reduce 1 112)
    (315, Token (DARROW _)) -> Just (Reduce 1 112)
    (315, Token (PIPE _)) -> Just (Reduce 1 112)
    (315, Token (COLON_COLON _)) -> Just (Reduce 1 112)
    (315, Token (MINUS _)) -> Just (Reduce 1 112)
    (315, Token (INFIXL _)) -> Just (Reduce 1 112)
    (315, Token (INFIXR _)) -> Just (Reduce 1 112)
    (315, Token (INFIX _)) -> Just (Reduce 1 112)
    (315, Token (RARROW _)) -> Just (Reduce 1 112)
    (315, Token (LBRACKET _)) -> Just (Reduce 1 112)
    (315, Token (RBRACKET _)) -> Just (Reduce 1 112)
    (315, Token (EXCL _)) -> Just (Reduce 1 112)
    (315, Token (QCONID _)) -> Just (Reduce 1 112)
    (315, Token (EXPORT _)) -> Just (Reduce 1 112)
    (315, Token (AS _)) -> Just (Reduce 1 112)
    (315, Token (QVARID _)) -> Just (Reduce 1 112)
    (315, Token (LARROW _)) -> Just (Reduce 1 112)
    (315, Token (THEN _)) -> Just (Reduce 1 112)
    (315, Token (ELSE _)) -> Just (Reduce 1 112)
    (315, Token (QVARSYM _)) -> Just (Reduce 1 112)
    (315, Token (BACKQUOTE _)) -> Just (Reduce 1 112)
    (315, Token (QCONSYM _)) -> Just (Reduce 1 112)
    (315, Token (INTEGER _)) -> Just (Reduce 1 112)
    (316, Token (LBRACE _)) -> Just (Shift 82)
    (316, Token (RBRACE _)) -> Just (Reduce 1 112)
    (316, Token (LPAREN _)) -> Just (Reduce 1 112)
    (316, Token (RPAREN _)) -> Just (Reduce 1 112)
    (316, Token (COMMA _)) -> Just (Reduce 1 112)
    (316, Token (SEMICOLON _)) -> Just (Reduce 1 112)
    (316, Token (DERIVING _)) -> Just (Reduce 1 112)
    (316, Token (PIPE _)) -> Just (Reduce 1 112)
    (316, Token (RARROW _)) -> Just (Reduce 1 112)
    (316, Token (LBRACKET _)) -> Just (Reduce 1 112)
    (316, Token (RBRACKET _)) -> Just (Reduce 1 112)
    (316, Token (EXCL _)) -> Just (Reduce 1 112)
    (316, Token (QCONID _)) -> Just (Reduce 1 112)
    (316, Token (EXPORT _)) -> Just (Reduce 1 112)
    (316, Token (AS _)) -> Just (Reduce 1 112)
    (316, Token (QVARID _)) -> Just (Reduce 1 112)
    (316, Token (BACKQUOTE _)) -> Just (Reduce 1 112)
    (316, Token (QCONSYM _)) -> Just (Reduce 1 112)
    (317, Token (RPAREN _)) -> Just (Shift 312)
    (318, Token (WHERE _)) -> Just (Reduce 1 201)
    (318, Token (LBRACE _)) -> Just (Reduce 1 201)
    (318, Token (RBRACE _)) -> Just (Reduce 1 201)
    (318, Token (LPAREN _)) -> Just (Reduce 1 201)
    (318, Token (RPAREN _)) -> Just (Reduce 1 201)
    (318, Token (COMMA _)) -> Just (Reduce 1 201)
    (318, Token (SEMICOLON _)) -> Just (Reduce 1 201)
    (318, Token (EQUAL _)) -> Just (Reduce 1 201)
    (318, Token (DERIVING _)) -> Just (Reduce 1 201)
    (318, Token (DARROW _)) -> Just (Reduce 1 201)
    (318, Token (PIPE _)) -> Just (Reduce 1 201)
    (318, Token (COLON_COLON _)) -> Just (Reduce 1 201)
    (318, Token (MINUS _)) -> Just (Reduce 1 201)
    (318, Token (INFIXL _)) -> Just (Reduce 1 201)
    (318, Token (INFIXR _)) -> Just (Reduce 1 201)
    (318, Token (INFIX _)) -> Just (Reduce 1 201)
    (318, Token (RARROW _)) -> Just (Reduce 1 201)
    (318, Token (LBRACKET _)) -> Just (Reduce 1 201)
    (318, Token (RBRACKET _)) -> Just (Reduce 1 201)
    (318, Token (EXCL _)) -> Just (Reduce 1 201)
    (318, Token (QCONID _)) -> Just (Reduce 1 201)
    (318, Token (EXPORT _)) -> Just (Reduce 1 201)
    (318, Token (AS _)) -> Just (Reduce 1 201)
    (318, Token (QVARID _)) -> Just (Reduce 1 201)
    (318, Token (LARROW _)) -> Just (Reduce 1 201)
    (318, Token (THEN _)) -> Just (Reduce 1 201)
    (318, Token (ELSE _)) -> Just (Reduce 1 201)
    (318, Token (QVARSYM _)) -> Just (Reduce 1 201)
    (318, Token (BACKQUOTE _)) -> Just (Reduce 1 201)
    (318, Token (QCONSYM _)) -> Just (Reduce 1 201)
    (318, Token (INTEGER _)) -> Just (Reduce 1 201)
    (319, Token (WHERE _)) -> Just (Reduce 1 200)
    (319, Token (LBRACE _)) -> Just (Reduce 1 200)
    (319, Token (RBRACE _)) -> Just (Reduce 1 200)
    (319, Token (LPAREN _)) -> Just (Reduce 1 200)
    (319, Token (RPAREN _)) -> Just (Reduce 1 200)
    (319, Token (COMMA _)) -> Just (Reduce 1 200)
    (319, Token (SEMICOLON _)) -> Just (Reduce 1 200)
    (319, Token (EQUAL _)) -> Just (Reduce 1 200)
    (319, Token (DERIVING _)) -> Just (Reduce 1 200)
    (319, Token (DARROW _)) -> Just (Reduce 1 200)
    (319, Token (PIPE _)) -> Just (Reduce 1 200)
    (319, Token (COLON_COLON _)) -> Just (Reduce 1 200)
    (319, Token (MINUS _)) -> Just (Reduce 1 200)
    (319, Token (INFIXL _)) -> Just (Reduce 1 200)
    (319, Token (INFIXR _)) -> Just (Reduce 1 200)
    (319, Token (INFIX _)) -> Just (Reduce 1 200)
    (319, Token (RARROW _)) -> Just (Reduce 1 200)
    (319, Token (LBRACKET _)) -> Just (Reduce 1 200)
    (319, Token (RBRACKET _)) -> Just (Reduce 1 200)
    (319, Token (EXCL _)) -> Just (Reduce 1 200)
    (319, Token (QCONID _)) -> Just (Reduce 1 200)
    (319, Token (EXPORT _)) -> Just (Reduce 1 200)
    (319, Token (AS _)) -> Just (Reduce 1 200)
    (319, Token (QVARID _)) -> Just (Reduce 1 200)
    (319, Token (LARROW _)) -> Just (Reduce 1 200)
    (319, Token (THEN _)) -> Just (Reduce 1 200)
    (319, Token (ELSE _)) -> Just (Reduce 1 200)
    (319, Token (QVARSYM _)) -> Just (Reduce 1 200)
    (319, Token (BACKQUOTE _)) -> Just (Reduce 1 200)
    (319, Token (QCONSYM _)) -> Just (Reduce 1 200)
    (319, Token (INTEGER _)) -> Just (Reduce 1 200)
    (320, Token (WHERE _)) -> Just (Reduce 1 202)
    (320, Token (LBRACE _)) -> Just (Reduce 1 202)
    (320, Token (RBRACE _)) -> Just (Reduce 1 202)
    (320, Token (LPAREN _)) -> Just (Reduce 1 202)
    (320, Token (RPAREN _)) -> Just (Reduce 1 202)
    (320, Token (COMMA _)) -> Just (Reduce 1 202)
    (320, Token (SEMICOLON _)) -> Just (Reduce 1 202)
    (320, Token (EQUAL _)) -> Just (Reduce 1 202)
    (320, Token (DERIVING _)) -> Just (Reduce 1 202)
    (320, Token (DARROW _)) -> Just (Reduce 1 202)
    (320, Token (PIPE _)) -> Just (Reduce 1 202)
    (320, Token (COLON_COLON _)) -> Just (Reduce 1 202)
    (320, Token (MINUS _)) -> Just (Reduce 1 202)
    (320, Token (INFIXL _)) -> Just (Reduce 1 202)
    (320, Token (INFIXR _)) -> Just (Reduce 1 202)
    (320, Token (INFIX _)) -> Just (Reduce 1 202)
    (320, Token (RARROW _)) -> Just (Reduce 1 202)
    (320, Token (LBRACKET _)) -> Just (Reduce 1 202)
    (320, Token (RBRACKET _)) -> Just (Reduce 1 202)
    (320, Token (EXCL _)) -> Just (Reduce 1 202)
    (320, Token (QCONID _)) -> Just (Reduce 1 202)
    (320, Token (EXPORT _)) -> Just (Reduce 1 202)
    (320, Token (AS _)) -> Just (Reduce 1 202)
    (320, Token (QVARID _)) -> Just (Reduce 1 202)
    (320, Token (LARROW _)) -> Just (Reduce 1 202)
    (320, Token (THEN _)) -> Just (Reduce 1 202)
    (320, Token (ELSE _)) -> Just (Reduce 1 202)
    (320, Token (QVARSYM _)) -> Just (Reduce 1 202)
    (320, Token (BACKQUOTE _)) -> Just (Reduce 1 202)
    (320, Token (QCONSYM _)) -> Just (Reduce 1 202)
    (320, Token (INTEGER _)) -> Just (Reduce 1 202)
    (321, Token (RPAREN _)) -> Just (Reduce 3 110)
    (321, Token (COMMA _)) -> Just (Shift 140)
    (322, Token (RPAREN _)) -> Just (Reduce 3 111)
    (323, Token (RPAREN _)) -> Just (Reduce 1 117)
    (323, Token (COMMA _)) -> Just (Shift 323)
    (324, Token (RPAREN _)) -> Just (Reduce 2 118)
    (325, Token (RBRACE _)) -> Just (Reduce 3 122)
    (325, Token (SEMICOLON _)) -> Just (Reduce 3 122)
    (325, Token (DERIVING _)) -> Just (Reduce 3 122)
    (326, Token (RBRACE _)) -> Just (Reduce 1 121)
    (326, Token (SEMICOLON _)) -> Just (Reduce 1 121)
    (326, Token (DERIVING _)) -> Just (Reduce 1 121)
    (326, Token (PIPE _)) -> Just (Shift 116)
    (327, Token (RBRACE _)) -> Just (Reduce 3 125)
    (327, Token (SEMICOLON _)) -> Just (Reduce 3 125)
    (327, Token (DERIVING _)) -> Just (Reduce 3 125)
    (327, Token (PIPE _)) -> Just (Reduce 3 125)
    (328, Token (RBRACE _)) -> Just (Reduce 4 126)
    (328, Token (SEMICOLON _)) -> Just (Reduce 4 126)
    (328, Token (DERIVING _)) -> Just (Reduce 4 126)
    (328, Token (PIPE _)) -> Just (Reduce 4 126)
    (329, Token (RBRACE _)) -> Just (Shift 328)
    (330, Token (BACKQUOTE _)) -> Just (Shift 333)
    (331, Token (QCONID _)) -> Just (Shift 330)
    (331, Token (EXPORT _)) -> Just (Shift 385)
    (331, Token (AS _)) -> Just (Shift 386)
    (331, Token (QVARID _)) -> Just (Shift 387)
    (332, Token (QCONID _)) -> Just (Shift 330)
    (333, Token (RBRACE _)) -> Just (Reduce 3 193)
    (333, Token (LPAREN _)) -> Just (Reduce 3 193)
    (333, Token (RPAREN _)) -> Just (Reduce 3 193)
    (333, Token (COMMA _)) -> Just (Reduce 3 193)
    (333, Token (SEMICOLON _)) -> Just (Reduce 3 193)
    (333, Token (MINUS _)) -> Just (Reduce 3 193)
    (333, Token (RARROW _)) -> Just (Reduce 3 193)
    (333, Token (LBRACKET _)) -> Just (Reduce 3 193)
    (333, Token (RBRACKET _)) -> Just (Reduce 3 193)
    (333, Token (EXCL _)) -> Just (Reduce 3 193)
    (333, Token (QCONID _)) -> Just (Reduce 3 193)
    (333, Token (EXPORT _)) -> Just (Reduce 3 193)
    (333, Token (AS _)) -> Just (Reduce 3 193)
    (333, Token (QVARID _)) -> Just (Reduce 3 193)
    (333, Token (QVARSYM _)) -> Just (Reduce 3 193)
    (333, Token (BACKQUOTE _)) -> Just (Reduce 3 193)
    (333, Token (QCONSYM _)) -> Just (Reduce 3 193)
    (334, Token (RBRACE _)) -> Just (Reduce 1 192)
    (334, Token (LPAREN _)) -> Just (Reduce 1 192)
    (334, Token (RPAREN _)) -> Just (Reduce 1 192)
    (334, Token (COMMA _)) -> Just (Reduce 1 192)
    (334, Token (SEMICOLON _)) -> Just (Reduce 1 192)
    (334, Token (MINUS _)) -> Just (Reduce 1 192)
    (334, Token (RARROW _)) -> Just (Reduce 1 192)
    (334, Token (LBRACKET _)) -> Just (Reduce 1 192)
    (334, Token (RBRACKET _)) -> Just (Reduce 1 192)
    (334, Token (EXCL _)) -> Just (Reduce 1 192)
    (334, Token (QCONID _)) -> Just (Reduce 1 192)
    (334, Token (EXPORT _)) -> Just (Reduce 1 192)
    (334, Token (AS _)) -> Just (Reduce 1 192)
    (334, Token (QVARID _)) -> Just (Reduce 1 192)
    (334, Token (QVARSYM _)) -> Just (Reduce 1 192)
    (334, Token (BACKQUOTE _)) -> Just (Reduce 1 192)
    (334, Token (QCONSYM _)) -> Just (Reduce 1 192)
    (335, Token (RBRACE _)) -> Just (Reduce 3 130)
    (336, Token (RBRACE _)) -> Just (Reduce 1 129)
    (336, Token (COMMA _)) -> Just (Shift 83)
    (337, Token (RBRACE _)) -> Just (Reduce 3 131)
    (337, Token (COMMA _)) -> Just (Reduce 3 131)
    (338, Token (COLON_COLON _)) -> Just (Shift 128)
    (339, Token (EXPORT _)) -> Just (Reduce 1 139)
    (339, Token (AS _)) -> Just (Reduce 1 139)
    (339, Token (QVARID _)) -> Just (Reduce 1 139)
    (339, Token (STRING _)) -> Just (Reduce 1 139)
    (340, Token (EXPORT _)) -> Just (Reduce 1 138)
    (340, Token (AS _)) -> Just (Reduce 1 138)
    (340, Token (QVARID _)) -> Just (Reduce 1 138)
    (340, Token (STRING _)) -> Just (Reduce 1 138)
    (341, Token (EXPORT _)) -> Just (Reduce 1 140)
    (341, Token (AS _)) -> Just (Reduce 1 140)
    (341, Token (QVARID _)) -> Just (Reduce 1 140)
    (341, Token (STRING _)) -> Just (Reduce 1 140)
    (342, Token (LPAREN _)) -> Just (Reduce 1 141)
    (342, Token (MINUS _)) -> Just (Reduce 1 141)
    (342, Token (EXPORT _)) -> Just (Reduce 1 141)
    (342, Token (AS _)) -> Just (Reduce 1 141)
    (342, Token (QVARID _)) -> Just (Reduce 1 141)
    (342, Token (QVARSYM _)) -> Just (Reduce 1 141)
    (343, Token (STRING _)) -> Just (Reduce 1 144)
    (344, Token (STRING _)) -> Just (Reduce 1 143)
    (345, Token (STRING _)) -> Just (Reduce 1 145)
    (346, Token (LPAREN _)) -> Just (Reduce 1 142)
    (346, Token (MINUS _)) -> Just (Reduce 1 142)
    (346, Token (EXPORT _)) -> Just (Reduce 1 142)
    (346, Token (AS _)) -> Just (Reduce 1 142)
    (346, Token (QVARID _)) -> Just (Reduce 1 142)
    (346, Token (QVARSYM _)) -> Just (Reduce 1 142)
    (347, Token (EQUAL _)) -> Just (Reduce 3 149)
    (348, Token (COMMA _)) -> Just (Shift 57)
    (348, Token (EQUAL _)) -> Just (Reduce 1 148)
    (349, Token (COMMA _)) -> Just (Reduce 2 151)
    (349, Token (EQUAL _)) -> Just (Reduce 2 151)
    (349, Token (IN _)) -> Just (Shift 36)
    (350, Token (COMMA _)) -> Just (Reduce 3 150)
    (350, Token (EQUAL _)) -> Just (Reduce 3 150)
    (351, Token (COMMA _)) -> Just (Reduce 1 152)
    (351, Token (EQUAL _)) -> Just (Reduce 1 152)
    (351, Token (LARROW _)) -> Just (Shift 60)
    (352, Token (BACKQUOTE _)) -> Just (Shift 39)
    (353, Token (BACKQUOTE _)) -> Just (Shift 40)
    (354, Token (BACKQUOTE _)) -> Just (Shift 41)
    (355, Token (BACKQUOTE _)) -> Just (Shift 42)
    (356, Token (QCONID _)) -> Just (Shift 352)
    (356, Token (EXPORT _)) -> Just (Shift 353)
    (356, Token (AS _)) -> Just (Shift 354)
    (356, Token (QVARID _)) -> Just (Shift 355)
    (357, Token (WHERE _)) -> Just (Reduce 5 165)
    (357, Token (RBRACE _)) -> Just (Reduce 5 165)
    (357, Token (RPAREN _)) -> Just (Reduce 5 165)
    (357, Token (COMMA _)) -> Just (Reduce 5 165)
    (357, Token (SEMICOLON _)) -> Just (Reduce 5 165)
    (357, Token (EQUAL _)) -> Just (Reduce 5 165)
    (357, Token (PIPE _)) -> Just (Reduce 5 165)
    (357, Token (LARROW _)) -> Just (Reduce 5 165)
    (357, Token (THEN _)) -> Just (Reduce 5 165)
    (357, Token (ELSE _)) -> Just (Reduce 5 165)
    (358, Token (WHERE _)) -> Just (Reduce 3 164)
    (358, Token (RBRACE _)) -> Just (Reduce 3 164)
    (358, Token (RPAREN _)) -> Just (Reduce 3 164)
    (358, Token (COMMA _)) -> Just (Reduce 3 164)
    (358, Token (SEMICOLON _)) -> Just (Reduce 3 164)
    (358, Token (EQUAL _)) -> Just (Reduce 3 164)
    (358, Token (PIPE _)) -> Just (Reduce 3 164)
    (358, Token (LARROW _)) -> Just (Reduce 3 164)
    (358, Token (THEN _)) -> Just (Reduce 3 164)
    (358, Token (ELSE _)) -> Just (Reduce 3 164)
    (359, Token (IN _)) -> Just (Shift 36)
    (360, Token (WHERE _)) -> Just (Reduce 3 157)
    (360, Token (RBRACE _)) -> Just (Reduce 3 157)
    (360, Token (RPAREN _)) -> Just (Reduce 3 157)
    (360, Token (COMMA _)) -> Just (Reduce 3 157)
    (360, Token (SEMICOLON _)) -> Just (Reduce 3 157)
    (360, Token (EQUAL _)) -> Just (Reduce 3 157)
    (360, Token (PIPE _)) -> Just (Reduce 3 157)
    (360, Token (LARROW _)) -> Just (Reduce 3 157)
    (360, Token (THEN _)) -> Just (Reduce 3 157)
    (360, Token (ELSE _)) -> Just (Reduce 3 157)
    (361, Token (WHERE _)) -> Just (Reduce 4 154)
    (361, Token (RBRACE _)) -> Just (Reduce 4 154)
    (361, Token (RPAREN _)) -> Just (Reduce 4 154)
    (361, Token (COMMA _)) -> Just (Reduce 4 154)
    (361, Token (SEMICOLON _)) -> Just (Reduce 4 154)
    (361, Token (EQUAL _)) -> Just (Reduce 4 154)
    (361, Token (PIPE _)) -> Just (Reduce 4 154)
    (361, Token (LARROW _)) -> Just (Reduce 4 154)
    (361, Token (THEN _)) -> Just (Reduce 4 154)
    (361, Token (ELSE _)) -> Just (Reduce 4 154)
    (362, Token (WHERE _)) -> Just (Reduce 4 155)
    (362, Token (RBRACE _)) -> Just (Reduce 4 155)
    (362, Token (RPAREN _)) -> Just (Reduce 4 155)
    (362, Token (COMMA _)) -> Just (Reduce 4 155)
    (362, Token (SEMICOLON _)) -> Just (Reduce 4 155)
    (362, Token (EQUAL _)) -> Just (Reduce 4 155)
    (362, Token (PIPE _)) -> Just (Reduce 4 155)
    (362, Token (LARROW _)) -> Just (Reduce 4 155)
    (362, Token (THEN _)) -> Just (Reduce 4 155)
    (362, Token (ELSE _)) -> Just (Reduce 4 155)
    (363, Token (SEMICOLON _)) -> Just (Shift 375)
    (363, Token (THEN _)) -> Just (Reduce 0 207)
    (364, Token (SEMICOLON _)) -> Just (Shift 375)
    (364, Token (ELSE _)) -> Just (Reduce 0 207)
    (365, Token (WHERE _)) -> Just (Reduce 8 156)
    (365, Token (RBRACE _)) -> Just (Reduce 8 156)
    (365, Token (RPAREN _)) -> Just (Reduce 8 156)
    (365, Token (COMMA _)) -> Just (Reduce 8 156)
    (365, Token (SEMICOLON _)) -> Just (Reduce 8 156)
    (365, Token (EQUAL _)) -> Just (Reduce 8 156)
    (365, Token (PIPE _)) -> Just (Reduce 8 156)
    (365, Token (LARROW _)) -> Just (Reduce 8 156)
    (365, Token (THEN _)) -> Just (Reduce 8 156)
    (365, Token (ELSE _)) -> Just (Reduce 8 156)
    (366, Token (WHERE _)) -> Just (Reduce 3 158)
    (366, Token (RBRACE _)) -> Just (Reduce 3 158)
    (366, Token (RPAREN _)) -> Just (Reduce 3 158)
    (366, Token (COMMA _)) -> Just (Reduce 3 158)
    (366, Token (SEMICOLON _)) -> Just (Reduce 3 158)
    (366, Token (EQUAL _)) -> Just (Reduce 3 158)
    (366, Token (PIPE _)) -> Just (Reduce 3 158)
    (366, Token (LARROW _)) -> Just (Reduce 3 158)
    (366, Token (THEN _)) -> Just (Reduce 3 158)
    (366, Token (ELSE _)) -> Just (Reduce 3 158)
    (367, Token (WHERE _)) -> Just (Reduce 5 163)
    (367, Token (RBRACE _)) -> Just (Reduce 5 163)
    (367, Token (RPAREN _)) -> Just (Reduce 5 163)
    (367, Token (COMMA _)) -> Just (Reduce 5 163)
    (367, Token (SEMICOLON _)) -> Just (Reduce 5 163)
    (367, Token (EQUAL _)) -> Just (Reduce 5 163)
    (367, Token (PIPE _)) -> Just (Reduce 5 163)
    (367, Token (LARROW _)) -> Just (Reduce 5 163)
    (367, Token (THEN _)) -> Just (Reduce 5 163)
    (367, Token (ELSE _)) -> Just (Reduce 5 163)
    (368, Token (WHERE _)) -> Just (Reduce 5 160)
    (368, Token (RBRACE _)) -> Just (Reduce 5 160)
    (368, Token (RPAREN _)) -> Just (Reduce 5 160)
    (368, Token (COMMA _)) -> Just (Reduce 5 160)
    (368, Token (SEMICOLON _)) -> Just (Reduce 5 160)
    (368, Token (EQUAL _)) -> Just (Reduce 5 160)
    (368, Token (PIPE _)) -> Just (Reduce 5 160)
    (368, Token (LARROW _)) -> Just (Reduce 5 160)
    (368, Token (THEN _)) -> Just (Reduce 5 160)
    (368, Token (ELSE _)) -> Just (Reduce 5 160)
    (369, Token (WHERE _)) -> Just (Reduce 5 159)
    (369, Token (RBRACE _)) -> Just (Reduce 5 159)
    (369, Token (RPAREN _)) -> Just (Reduce 5 159)
    (369, Token (COMMA _)) -> Just (Reduce 5 159)
    (369, Token (SEMICOLON _)) -> Just (Reduce 5 159)
    (369, Token (EQUAL _)) -> Just (Reduce 5 159)
    (369, Token (PIPE _)) -> Just (Reduce 5 159)
    (369, Token (LARROW _)) -> Just (Reduce 5 159)
    (369, Token (THEN _)) -> Just (Reduce 5 159)
    (369, Token (ELSE _)) -> Just (Reduce 5 159)
    (370, Token (WHERE _)) -> Just (Reduce 5 161)
    (370, Token (RBRACE _)) -> Just (Reduce 5 161)
    (370, Token (RPAREN _)) -> Just (Reduce 5 161)
    (370, Token (COMMA _)) -> Just (Reduce 5 161)
    (370, Token (SEMICOLON _)) -> Just (Reduce 5 161)
    (370, Token (EQUAL _)) -> Just (Reduce 5 161)
    (370, Token (PIPE _)) -> Just (Reduce 5 161)
    (370, Token (LARROW _)) -> Just (Reduce 5 161)
    (370, Token (THEN _)) -> Just (Reduce 5 161)
    (370, Token (ELSE _)) -> Just (Reduce 5 161)
    (371, Token (WHERE _)) -> Just (Reduce 3 162)
    (371, Token (RBRACE _)) -> Just (Reduce 3 162)
    (371, Token (RPAREN _)) -> Just (Reduce 3 162)
    (371, Token (COMMA _)) -> Just (Reduce 3 162)
    (371, Token (SEMICOLON _)) -> Just (Reduce 3 162)
    (371, Token (EQUAL _)) -> Just (Reduce 3 162)
    (371, Token (PIPE _)) -> Just (Reduce 3 162)
    (371, Token (LARROW _)) -> Just (Reduce 3 162)
    (371, Token (THEN _)) -> Just (Reduce 3 162)
    (371, Token (ELSE _)) -> Just (Reduce 3 162)
    (372, Token (THEN _)) -> Just (Shift 59)
    (373, Token (ELSE _)) -> Just (Shift 37)
    (374, Token (WHERE _)) -> Just (Reduce 1 166)
    (374, Token (RBRACE _)) -> Just (Reduce 1 166)
    (374, Token (RPAREN _)) -> Just (Reduce 1 166)
    (374, Token (COMMA _)) -> Just (Reduce 1 166)
    (374, Token (SEMICOLON _)) -> Just (Reduce 1 166)
    (374, Token (EQUAL _)) -> Just (Reduce 1 166)
    (374, Token (PIPE _)) -> Just (Reduce 1 166)
    (374, Token (COLON_COLON _)) -> Just (Shift 106)
    (374, Token (MINUS _)) -> Just (Shift 34)
    (374, Token (LARROW _)) -> Just (Reduce 1 166)
    (374, Token (THEN _)) -> Just (Reduce 1 166)
    (374, Token (ELSE _)) -> Just (Reduce 1 166)
    (374, Token (QVARSYM _)) -> Just (Shift 38)
    (374, Token (BACKQUOTE _)) -> Just (Shift 356)
    (374, Token (QCONSYM _)) -> Just (Shift 43)
    (375, Token (THEN _)) -> Just (Reduce 1 208)
    (375, Token (ELSE _)) -> Just (Reduce 1 208)
    (376, Token (WHERE _)) -> Just (Reduce 1 169)
    (376, Token (LBRACE _)) -> Just (Reduce 1 169)
    (376, Token (RBRACE _)) -> Just (Reduce 1 169)
    (376, Token (LPAREN _)) -> Just (Reduce 1 169)
    (376, Token (RPAREN _)) -> Just (Reduce 1 169)
    (376, Token (COMMA _)) -> Just (Reduce 1 169)
    (376, Token (SEMICOLON _)) -> Just (Reduce 1 169)
    (376, Token (EQUAL _)) -> Just (Reduce 1 169)
    (376, Token (PIPE _)) -> Just (Reduce 1 169)
    (376, Token (COLON_COLON _)) -> Just (Reduce 1 169)
    (376, Token (MINUS _)) -> Just (Reduce 1 169)
    (376, Token (INFIXL _)) -> Just (Reduce 1 169)
    (376, Token (INFIXR _)) -> Just (Reduce 1 169)
    (376, Token (INFIX _)) -> Just (Reduce 1 169)
    (376, Token (QCONID _)) -> Just (Reduce 1 169)
    (376, Token (EXPORT _)) -> Just (Reduce 1 169)
    (376, Token (AS _)) -> Just (Reduce 1 169)
    (376, Token (QVARID _)) -> Just (Reduce 1 169)
    (376, Token (STRING _)) -> Just (Reduce 1 169)
    (376, Token (LARROW _)) -> Just (Reduce 1 169)
    (376, Token (LET _)) -> Just (Reduce 1 169)
    (376, Token (LAMBDA _)) -> Just (Reduce 1 169)
    (376, Token (IF _)) -> Just (Reduce 1 169)
    (376, Token (THEN _)) -> Just (Reduce 1 169)
    (376, Token (ELSE _)) -> Just (Reduce 1 169)
    (376, Token (QVARSYM _)) -> Just (Reduce 1 169)
    (376, Token (BACKQUOTE _)) -> Just (Reduce 1 169)
    (376, Token (QCONSYM _)) -> Just (Reduce 1 169)
    (376, Token (INTEGER _)) -> Just (Reduce 1 169)
    (377, Token (WHERE _)) -> Just (Reduce 2 170)
    (377, Token (LBRACE _)) -> Just (Reduce 2 170)
    (377, Token (RBRACE _)) -> Just (Reduce 2 170)
    (377, Token (LPAREN _)) -> Just (Reduce 2 170)
    (377, Token (RPAREN _)) -> Just (Reduce 2 170)
    (377, Token (COMMA _)) -> Just (Reduce 2 170)
    (377, Token (SEMICOLON _)) -> Just (Reduce 2 170)
    (377, Token (EQUAL _)) -> Just (Reduce 2 170)
    (377, Token (PIPE _)) -> Just (Reduce 2 170)
    (377, Token (COLON_COLON _)) -> Just (Reduce 2 170)
    (377, Token (MINUS _)) -> Just (Reduce 2 170)
    (377, Token (INFIXL _)) -> Just (Reduce 2 170)
    (377, Token (INFIXR _)) -> Just (Reduce 2 170)
    (377, Token (INFIX _)) -> Just (Reduce 2 170)
    (377, Token (QCONID _)) -> Just (Reduce 2 170)
    (377, Token (EXPORT _)) -> Just (Reduce 2 170)
    (377, Token (AS _)) -> Just (Reduce 2 170)
    (377, Token (QVARID _)) -> Just (Reduce 2 170)
    (377, Token (STRING _)) -> Just (Reduce 2 170)
    (377, Token (LARROW _)) -> Just (Reduce 2 170)
    (377, Token (LET _)) -> Just (Reduce 2 170)
    (377, Token (LAMBDA _)) -> Just (Reduce 2 170)
    (377, Token (IF _)) -> Just (Reduce 2 170)
    (377, Token (THEN _)) -> Just (Reduce 2 170)
    (377, Token (ELSE _)) -> Just (Reduce 2 170)
    (377, Token (QVARSYM _)) -> Just (Reduce 2 170)
    (377, Token (BACKQUOTE _)) -> Just (Reduce 2 170)
    (377, Token (QCONSYM _)) -> Just (Reduce 2 170)
    (377, Token (INTEGER _)) -> Just (Reduce 2 170)
    (378, Token (WHERE _)) -> Just (Reduce 3 174)
    (378, Token (LBRACE _)) -> Just (Reduce 3 174)
    (378, Token (RBRACE _)) -> Just (Reduce 3 174)
    (378, Token (LPAREN _)) -> Just (Reduce 3 174)
    (378, Token (RPAREN _)) -> Just (Reduce 3 174)
    (378, Token (COMMA _)) -> Just (Reduce 3 174)
    (378, Token (SEMICOLON _)) -> Just (Reduce 3 174)
    (378, Token (EQUAL _)) -> Just (Reduce 3 174)
    (378, Token (PIPE _)) -> Just (Reduce 3 174)
    (378, Token (COLON_COLON _)) -> Just (Reduce 3 174)
    (378, Token (MINUS _)) -> Just (Reduce 3 174)
    (378, Token (INFIXL _)) -> Just (Reduce 3 174)
    (378, Token (INFIXR _)) -> Just (Reduce 3 174)
    (378, Token (INFIX _)) -> Just (Reduce 3 174)
    (378, Token (QCONID _)) -> Just (Reduce 3 174)
    (378, Token (EXPORT _)) -> Just (Reduce 3 174)
    (378, Token (AS _)) -> Just (Reduce 3 174)
    (378, Token (QVARID _)) -> Just (Reduce 3 174)
    (378, Token (STRING _)) -> Just (Reduce 3 174)
    (378, Token (LARROW _)) -> Just (Reduce 3 174)
    (378, Token (LET _)) -> Just (Reduce 3 174)
    (378, Token (LAMBDA _)) -> Just (Reduce 3 174)
    (378, Token (IF _)) -> Just (Reduce 3 174)
    (378, Token (THEN _)) -> Just (Reduce 3 174)
    (378, Token (ELSE _)) -> Just (Reduce 3 174)
    (378, Token (QVARSYM _)) -> Just (Reduce 3 174)
    (378, Token (BACKQUOTE _)) -> Just (Reduce 3 174)
    (378, Token (QCONSYM _)) -> Just (Reduce 3 174)
    (378, Token (INTEGER _)) -> Just (Reduce 3 174)
    (379, Token (WHERE _)) -> Just (Reduce 1 173)
    (379, Token (LBRACE _)) -> Just (Reduce 1 173)
    (379, Token (RBRACE _)) -> Just (Reduce 1 173)
    (379, Token (LPAREN _)) -> Just (Reduce 1 173)
    (379, Token (RPAREN _)) -> Just (Reduce 1 173)
    (379, Token (COMMA _)) -> Just (Reduce 1 173)
    (379, Token (SEMICOLON _)) -> Just (Reduce 1 173)
    (379, Token (EQUAL _)) -> Just (Reduce 1 173)
    (379, Token (PIPE _)) -> Just (Reduce 1 173)
    (379, Token (COLON_COLON _)) -> Just (Reduce 1 173)
    (379, Token (MINUS _)) -> Just (Reduce 1 173)
    (379, Token (INFIXL _)) -> Just (Reduce 1 173)
    (379, Token (INFIXR _)) -> Just (Reduce 1 173)
    (379, Token (INFIX _)) -> Just (Reduce 1 173)
    (379, Token (QCONID _)) -> Just (Reduce 1 173)
    (379, Token (EXPORT _)) -> Just (Reduce 1 173)
    (379, Token (AS _)) -> Just (Reduce 1 173)
    (379, Token (QVARID _)) -> Just (Reduce 1 173)
    (379, Token (STRING _)) -> Just (Reduce 1 173)
    (379, Token (LARROW _)) -> Just (Reduce 1 173)
    (379, Token (LET _)) -> Just (Reduce 1 173)
    (379, Token (LAMBDA _)) -> Just (Reduce 1 173)
    (379, Token (IF _)) -> Just (Reduce 1 173)
    (379, Token (THEN _)) -> Just (Reduce 1 173)
    (379, Token (ELSE _)) -> Just (Reduce 1 173)
    (379, Token (QVARSYM _)) -> Just (Reduce 1 173)
    (379, Token (BACKQUOTE _)) -> Just (Reduce 1 173)
    (379, Token (QCONSYM _)) -> Just (Reduce 1 173)
    (379, Token (INTEGER _)) -> Just (Reduce 1 173)
    (380, Token (WHERE _)) -> Just (Reduce 1 172)
    (380, Token (LBRACE _)) -> Just (Reduce 1 172)
    (380, Token (RBRACE _)) -> Just (Reduce 1 172)
    (380, Token (LPAREN _)) -> Just (Reduce 1 172)
    (380, Token (RPAREN _)) -> Just (Reduce 1 172)
    (380, Token (COMMA _)) -> Just (Reduce 1 172)
    (380, Token (SEMICOLON _)) -> Just (Reduce 1 172)
    (380, Token (EQUAL _)) -> Just (Reduce 1 172)
    (380, Token (PIPE _)) -> Just (Reduce 1 172)
    (380, Token (COLON_COLON _)) -> Just (Reduce 1 172)
    (380, Token (MINUS _)) -> Just (Reduce 1 172)
    (380, Token (INFIXL _)) -> Just (Reduce 1 172)
    (380, Token (INFIXR _)) -> Just (Reduce 1 172)
    (380, Token (INFIX _)) -> Just (Reduce 1 172)
    (380, Token (QCONID _)) -> Just (Reduce 1 172)
    (380, Token (EXPORT _)) -> Just (Reduce 1 172)
    (380, Token (AS _)) -> Just (Reduce 1 172)
    (380, Token (QVARID _)) -> Just (Reduce 1 172)
    (380, Token (STRING _)) -> Just (Reduce 1 172)
    (380, Token (LARROW _)) -> Just (Reduce 1 172)
    (380, Token (LET _)) -> Just (Reduce 1 172)
    (380, Token (LAMBDA _)) -> Just (Reduce 1 172)
    (380, Token (IF _)) -> Just (Reduce 1 172)
    (380, Token (THEN _)) -> Just (Reduce 1 172)
    (380, Token (ELSE _)) -> Just (Reduce 1 172)
    (380, Token (QVARSYM _)) -> Just (Reduce 1 172)
    (380, Token (BACKQUOTE _)) -> Just (Reduce 1 172)
    (380, Token (QCONSYM _)) -> Just (Reduce 1 172)
    (380, Token (INTEGER _)) -> Just (Reduce 1 172)
    (381, Token (WHERE _)) -> Just (Reduce 1 171)
    (381, Token (LBRACE _)) -> Just (Reduce 1 171)
    (381, Token (RBRACE _)) -> Just (Reduce 1 171)
    (381, Token (LPAREN _)) -> Just (Reduce 1 171)
    (381, Token (RPAREN _)) -> Just (Reduce 1 171)
    (381, Token (COMMA _)) -> Just (Reduce 1 171)
    (381, Token (SEMICOLON _)) -> Just (Reduce 1 171)
    (381, Token (EQUAL _)) -> Just (Reduce 1 171)
    (381, Token (PIPE _)) -> Just (Reduce 1 171)
    (381, Token (COLON_COLON _)) -> Just (Reduce 1 171)
    (381, Token (MINUS _)) -> Just (Reduce 1 171)
    (381, Token (INFIXL _)) -> Just (Reduce 1 171)
    (381, Token (INFIXR _)) -> Just (Reduce 1 171)
    (381, Token (INFIX _)) -> Just (Reduce 1 171)
    (381, Token (QCONID _)) -> Just (Reduce 1 171)
    (381, Token (EXPORT _)) -> Just (Reduce 1 171)
    (381, Token (AS _)) -> Just (Reduce 1 171)
    (381, Token (QVARID _)) -> Just (Reduce 1 171)
    (381, Token (STRING _)) -> Just (Reduce 1 171)
    (381, Token (LARROW _)) -> Just (Reduce 1 171)
    (381, Token (LET _)) -> Just (Reduce 1 171)
    (381, Token (LAMBDA _)) -> Just (Reduce 1 171)
    (381, Token (IF _)) -> Just (Reduce 1 171)
    (381, Token (THEN _)) -> Just (Reduce 1 171)
    (381, Token (ELSE _)) -> Just (Reduce 1 171)
    (381, Token (QVARSYM _)) -> Just (Reduce 1 171)
    (381, Token (BACKQUOTE _)) -> Just (Reduce 1 171)
    (381, Token (QCONSYM _)) -> Just (Reduce 1 171)
    (381, Token (INTEGER _)) -> Just (Reduce 1 171)
    (382, Token (RPAREN _)) -> Just (Shift 378)
    (383, Token (LPAREN _)) -> Just (Reduce 3 180)
    (383, Token (RPAREN _)) -> Just (Reduce 3 180)
    (383, Token (EQUAL _)) -> Just (Reduce 3 180)
    (383, Token (PIPE _)) -> Just (Reduce 3 180)
    (383, Token (MINUS _)) -> Just (Reduce 3 180)
    (383, Token (RARROW _)) -> Just (Reduce 3 180)
    (383, Token (QCONID _)) -> Just (Reduce 3 180)
    (383, Token (EXPORT _)) -> Just (Reduce 3 180)
    (383, Token (AS _)) -> Just (Reduce 3 180)
    (383, Token (QVARID _)) -> Just (Reduce 3 180)
    (383, Token (QVARSYM _)) -> Just (Reduce 3 180)
    (383, Token (BACKQUOTE _)) -> Just (Reduce 3 180)
    (383, Token (QCONSYM _)) -> Just (Reduce 3 180)
    (384, Token (LPAREN _)) -> Just (Reduce 1 179)
    (384, Token (RPAREN _)) -> Just (Reduce 1 179)
    (384, Token (EQUAL _)) -> Just (Reduce 1 179)
    (384, Token (PIPE _)) -> Just (Reduce 1 179)
    (384, Token (MINUS _)) -> Just (Reduce 1 179)
    (384, Token (RARROW _)) -> Just (Reduce 1 179)
    (384, Token (QCONID _)) -> Just (Reduce 1 179)
    (384, Token (EXPORT _)) -> Just (Reduce 1 179)
    (384, Token (AS _)) -> Just (Reduce 1 179)
    (384, Token (QVARID _)) -> Just (Reduce 1 179)
    (384, Token (QVARSYM _)) -> Just (Reduce 1 179)
    (384, Token (BACKQUOTE _)) -> Just (Reduce 1 179)
    (384, Token (QCONSYM _)) -> Just (Reduce 1 179)
    (385, Token (BACKQUOTE _)) -> Just (Shift 389)
    (386, Token (BACKQUOTE _)) -> Just (Shift 390)
    (387, Token (BACKQUOTE _)) -> Just (Shift 391)
    (388, Token (RBRACE _)) -> Just (Reduce 1 188)
    (388, Token (LPAREN _)) -> Just (Reduce 1 188)
    (388, Token (COMMA _)) -> Just (Reduce 1 188)
    (388, Token (SEMICOLON _)) -> Just (Reduce 1 188)
    (388, Token (MINUS _)) -> Just (Reduce 1 188)
    (388, Token (QCONID _)) -> Just (Reduce 1 188)
    (388, Token (EXPORT _)) -> Just (Reduce 1 188)
    (388, Token (AS _)) -> Just (Reduce 1 188)
    (388, Token (QVARID _)) -> Just (Reduce 1 188)
    (388, Token (QVARSYM _)) -> Just (Reduce 1 188)
    (388, Token (BACKQUOTE _)) -> Just (Reduce 1 188)
    (388, Token (QCONSYM _)) -> Just (Reduce 1 188)
    (389, Token (RBRACE _)) -> Just (Reduce 3 190)
    (389, Token (LPAREN _)) -> Just (Reduce 3 190)
    (389, Token (COMMA _)) -> Just (Reduce 3 190)
    (389, Token (SEMICOLON _)) -> Just (Reduce 3 190)
    (389, Token (MINUS _)) -> Just (Reduce 3 190)
    (389, Token (QCONID _)) -> Just (Reduce 3 190)
    (389, Token (EXPORT _)) -> Just (Reduce 3 190)
    (389, Token (AS _)) -> Just (Reduce 3 190)
    (389, Token (QVARID _)) -> Just (Reduce 3 190)
    (389, Token (QVARSYM _)) -> Just (Reduce 3 190)
    (389, Token (BACKQUOTE _)) -> Just (Reduce 3 190)
    (389, Token (QCONSYM _)) -> Just (Reduce 3 190)
    (390, Token (RBRACE _)) -> Just (Reduce 3 189)
    (390, Token (LPAREN _)) -> Just (Reduce 3 189)
    (390, Token (COMMA _)) -> Just (Reduce 3 189)
    (390, Token (SEMICOLON _)) -> Just (Reduce 3 189)
    (390, Token (MINUS _)) -> Just (Reduce 3 189)
    (390, Token (QCONID _)) -> Just (Reduce 3 189)
    (390, Token (EXPORT _)) -> Just (Reduce 3 189)
    (390, Token (AS _)) -> Just (Reduce 3 189)
    (390, Token (QVARID _)) -> Just (Reduce 3 189)
    (390, Token (QVARSYM _)) -> Just (Reduce 3 189)
    (390, Token (BACKQUOTE _)) -> Just (Reduce 3 189)
    (390, Token (QCONSYM _)) -> Just (Reduce 3 189)
    (391, Token (RBRACE _)) -> Just (Reduce 3 191)
    (391, Token (LPAREN _)) -> Just (Reduce 3 191)
    (391, Token (COMMA _)) -> Just (Reduce 3 191)
    (391, Token (SEMICOLON _)) -> Just (Reduce 3 191)
    (391, Token (MINUS _)) -> Just (Reduce 3 191)
    (391, Token (QCONID _)) -> Just (Reduce 3 191)
    (391, Token (EXPORT _)) -> Just (Reduce 3 191)
    (391, Token (AS _)) -> Just (Reduce 3 191)
    (391, Token (QVARID _)) -> Just (Reduce 3 191)
    (391, Token (QVARSYM _)) -> Just (Reduce 3 191)
    (391, Token (BACKQUOTE _)) -> Just (Reduce 3 191)
    (391, Token (QCONSYM _)) -> Just (Reduce 3 191)
    (_, _) -> Nothing

production :: Int -> Int
production 0 = 0
production 1 = 0
production 2 = 3
production 3 = 2
production 4 = 2
production 5 = 5
production 6 = 6
production 7 = 6
production 8 = 6
production 9 = 7
production 10 = 7
production 11 = 7
production 12 = 7
production 13 = 7
production 14 = 7
production 15 = 11
production 16 = 11
production 17 = 11
production 18 = 12
production 19 = 12
production 20 = 12
production 21 = 12
production 22 = 12
production 23 = 10
production 24 = 10
production 25 = 13
production 26 = 13
production 27 = 4
production 28 = 4
production 29 = 14
production 30 = 14
production 31 = 14
production 32 = 14
production 33 = 14
production 34 = 14
production 35 = 14
production 36 = 14
production 37 = 14
production 38 = 14
production 39 = 14
production 40 = 14
production 41 = 14
production 42 = 14
production 43 = 14
production 44 = 14
production 45 = 14
production 46 = 14
production 47 = 14
production 48 = 14
production 49 = 14
production 50 = 14
production 51 = 14
production 52 = 14
production 53 = 14
production 54 = 14
production 55 = 14
production 56 = 14
production 57 = 28
production 58 = 29
production 59 = 29
production 60 = 27
production 61 = 27
production 62 = 27
production 63 = 27
production 64 = 27
production 65 = 23
production 66 = 23
production 67 = 34
production 68 = 35
production 69 = 35
production 70 = 36
production 71 = 36
production 72 = 36
production 73 = 36
production 74 = 36
production 75 = 24
production 76 = 24
production 77 = 37
production 78 = 38
production 79 = 38
production 80 = 39
production 81 = 39
production 82 = 39
production 83 = 39
production 84 = 39
production 85 = 30
production 86 = 30
production 87 = 30
production 88 = 30
production 89 = 43
production 90 = 43
production 91 = 43
production 92 = 43
production 93 = 40
production 94 = 40
production 95 = 41
production 96 = 41
production 97 = 41
production 98 = 25
production 99 = 25
production 100 = 18
production 101 = 18
production 102 = 17
production 103 = 17
production 104 = 45
production 105 = 45
production 106 = 45
production 107 = 45
production 108 = 45
production 109 = 45
production 110 = 48
production 111 = 48
production 112 = 46
production 113 = 46
production 114 = 46
production 115 = 46
production 116 = 46
production 117 = 49
production 118 = 49
production 119 = 19
production 120 = 19
production 121 = 50
production 122 = 50
production 123 = 51
production 124 = 51
production 125 = 51
production 126 = 51
production 127 = 22
production 128 = 22
production 129 = 53
production 130 = 53
production 131 = 54
production 132 = 21
production 133 = 21
production 134 = 20
production 135 = 26
production 136 = 26
production 137 = 26
production 138 = 55
production 139 = 55
production 140 = 55
production 141 = 56
production 142 = 58
production 143 = 57
production 144 = 57
production 145 = 57
production 146 = 33
production 147 = 33
production 148 = 59
production 149 = 59
production 150 = 60
production 151 = 60
production 152 = 60
production 153 = 32
production 154 = 61
production 155 = 61
production 156 = 61
production 157 = 61
production 158 = 61
production 159 = 61
production 160 = 61
production 161 = 61
production 162 = 61
production 163 = 61
production 164 = 61
production 165 = 61
production 166 = 61
production 167 = 63
production 168 = 63
production 169 = 64
production 170 = 64
production 171 = 65
production 172 = 65
production 173 = 65
production 174 = 65
production 175 = 31
production 176 = 31
production 177 = 31
production 178 = 31
production 179 = 66
production 180 = 66
production 181 = 8
production 182 = 8
production 183 = 8
production 184 = 8
production 185 = 8
production 186 = 9
production 187 = 9
production 188 = 67
production 189 = 67
production 190 = 67
production 191 = 67
production 192 = 52
production 193 = 52
production 194 = 44
production 195 = 44
production 196 = 16
production 197 = 16
production 198 = 15
production 199 = 15
production 200 = 47
production 201 = 47
production 202 = 47
production 203 = 68
production 204 = 1
production 205 = 42
production 206 = 42
production 207 = 62
production 208 = 62

dfaGotoTransition :: GotoState -> GotoSymbol -> Maybe GotoState
dfaGotoTransition q s =
  case (q, production s) of
    (0, 0) -> Just 1
    (0, 3) -> Just 6
    (2, 1) -> Just 4
    (3, 3) -> Just 7
    (4, 2) -> Just 5
    (4, 5) -> Just 12
    (8, 1) -> Just 183
    (9, 1) -> Just 208
    (10, 1) -> Just 30
    (13, 4) -> Just 15
    (13, 8) -> Just 287
    (13, 14) -> Just 18
    (13, 27) -> Just 206
    (13, 30) -> Just 242
    (13, 31) -> Just 69
    (13, 40) -> Just 257
    (13, 41) -> Just 258
    (13, 66) -> Just 261
    (16, 4) -> Just 17
    (16, 8) -> Just 287
    (16, 14) -> Just 18
    (16, 27) -> Just 206
    (16, 30) -> Just 242
    (16, 31) -> Just 69
    (16, 40) -> Just 257
    (16, 41) -> Just 258
    (16, 66) -> Just 261
    (19, 6) -> Just 21
    (19, 7) -> Just 24
    (19, 8) -> Just 31
    (19, 9) -> Just 32
    (22, 6) -> Just 23
    (22, 7) -> Just 24
    (22, 8) -> Just 31
    (22, 9) -> Just 32
    (25, 8) -> Just 157
    (25, 9) -> Just 158
    (25, 10) -> Just 33
    (25, 13) -> Just 147
    (34, 8) -> Just 381
    (34, 32) -> Just 360
    (34, 61) -> Just 265
    (34, 63) -> Just 374
    (34, 64) -> Just 45
    (34, 65) -> Just 376
    (35, 8) -> Just 381
    (35, 32) -> Just 361
    (35, 61) -> Just 265
    (35, 63) -> Just 374
    (35, 64) -> Just 45
    (35, 65) -> Just 376
    (36, 8) -> Just 381
    (36, 32) -> Just 362
    (36, 61) -> Just 265
    (36, 63) -> Just 374
    (36, 64) -> Just 45
    (36, 65) -> Just 376
    (37, 8) -> Just 381
    (37, 32) -> Just 365
    (37, 61) -> Just 265
    (37, 63) -> Just 374
    (37, 64) -> Just 45
    (37, 65) -> Just 376
    (38, 8) -> Just 381
    (38, 32) -> Just 366
    (38, 61) -> Just 265
    (38, 63) -> Just 374
    (38, 64) -> Just 45
    (38, 65) -> Just 376
    (39, 8) -> Just 381
    (39, 32) -> Just 367
    (39, 61) -> Just 265
    (39, 63) -> Just 374
    (39, 64) -> Just 45
    (39, 65) -> Just 376
    (40, 8) -> Just 381
    (40, 32) -> Just 368
    (40, 61) -> Just 265
    (40, 63) -> Just 374
    (40, 64) -> Just 45
    (40, 65) -> Just 376
    (41, 8) -> Just 381
    (41, 32) -> Just 369
    (41, 61) -> Just 265
    (41, 63) -> Just 374
    (41, 64) -> Just 45
    (41, 65) -> Just 376
    (42, 8) -> Just 381
    (42, 32) -> Just 370
    (42, 61) -> Just 265
    (42, 63) -> Just 374
    (42, 64) -> Just 45
    (42, 65) -> Just 376
    (43, 8) -> Just 381
    (43, 32) -> Just 371
    (43, 61) -> Just 265
    (43, 63) -> Just 374
    (43, 64) -> Just 45
    (43, 65) -> Just 376
    (44, 8) -> Just 381
    (44, 64) -> Just 46
    (44, 65) -> Just 376
    (45, 8) -> Just 381
    (45, 65) -> Just 377
    (46, 8) -> Just 381
    (46, 65) -> Just 377
    (47, 8) -> Just 381
    (47, 32) -> Just 243
    (47, 61) -> Just 265
    (47, 63) -> Just 374
    (47, 64) -> Just 45
    (47, 65) -> Just 376
    (48, 8) -> Just 381
    (48, 32) -> Just 266
    (48, 61) -> Just 265
    (48, 63) -> Just 374
    (48, 64) -> Just 45
    (48, 65) -> Just 376
    (49, 8) -> Just 381
    (49, 32) -> Just 276
    (49, 61) -> Just 265
    (49, 63) -> Just 374
    (49, 64) -> Just 45
    (49, 65) -> Just 376
    (50, 8) -> Just 381
    (50, 32) -> Just 284
    (50, 61) -> Just 265
    (50, 63) -> Just 374
    (50, 64) -> Just 45
    (50, 65) -> Just 376
    (51, 8) -> Just 381
    (51, 32) -> Just 382
    (51, 61) -> Just 265
    (51, 63) -> Just 374
    (51, 64) -> Just 45
    (51, 65) -> Just 376
    (52, 8) -> Just 381
    (52, 64) -> Just 46
    (52, 65) -> Just 376
    (53, 8) -> Just 381
    (53, 33) -> Just 244
    (53, 59) -> Just 268
    (53, 60) -> Just 348
    (53, 61) -> Just 351
    (53, 63) -> Just 374
    (53, 64) -> Just 45
    (53, 65) -> Just 376
    (54, 8) -> Just 381
    (54, 33) -> Just 267
    (54, 59) -> Just 268
    (54, 60) -> Just 348
    (54, 61) -> Just 351
    (54, 63) -> Just 374
    (54, 64) -> Just 45
    (54, 65) -> Just 376
    (55, 8) -> Just 381
    (55, 33) -> Just 277
    (55, 59) -> Just 268
    (55, 60) -> Just 348
    (55, 61) -> Just 351
    (55, 63) -> Just 374
    (55, 64) -> Just 45
    (55, 65) -> Just 376
    (56, 8) -> Just 381
    (56, 33) -> Just 285
    (56, 59) -> Just 268
    (56, 60) -> Just 348
    (56, 61) -> Just 351
    (56, 63) -> Just 374
    (56, 64) -> Just 45
    (56, 65) -> Just 376
    (57, 8) -> Just 381
    (57, 59) -> Just 347
    (57, 60) -> Just 348
    (57, 61) -> Just 351
    (57, 63) -> Just 374
    (57, 64) -> Just 45
    (57, 65) -> Just 376
    (58, 8) -> Just 381
    (58, 32) -> Just 363
    (58, 61) -> Just 265
    (58, 63) -> Just 374
    (58, 64) -> Just 45
    (58, 65) -> Just 376
    (59, 8) -> Just 381
    (59, 32) -> Just 364
    (59, 61) -> Just 265
    (59, 63) -> Just 374
    (59, 64) -> Just 45
    (59, 65) -> Just 376
    (60, 8) -> Just 381
    (60, 32) -> Just 350
    (60, 61) -> Just 265
    (60, 63) -> Just 374
    (60, 64) -> Just 45
    (60, 65) -> Just 376
    (61, 8) -> Just 384
    (61, 66) -> Just 262
    (62, 8) -> Just 384
    (62, 66) -> Just 264
    (63, 8) -> Just 384
    (63, 31) -> Just 64
    (63, 66) -> Just 261
    (64, 8) -> Just 384
    (64, 44) -> Just 62
    (64, 52) -> Just 299
    (64, 66) -> Just 263
    (64, 67) -> Just 300
    (65, 8) -> Just 287
    (65, 27) -> Just 253
    (65, 29) -> Just 252
    (65, 30) -> Just 242
    (65, 31) -> Just 69
    (65, 40) -> Just 257
    (65, 41) -> Just 258
    (65, 66) -> Just 261
    (66, 8) -> Just 287
    (66, 27) -> Just 253
    (66, 29) -> Just 254
    (66, 30) -> Just 242
    (66, 31) -> Just 69
    (66, 40) -> Just 257
    (66, 41) -> Just 258
    (66, 66) -> Just 261
    (67, 8) -> Just 287
    (67, 30) -> Just 275
    (67, 31) -> Just 72
    (67, 35) -> Just 270
    (67, 36) -> Just 272
    (67, 40) -> Just 257
    (67, 41) -> Just 258
    (67, 66) -> Just 261
    (68, 8) -> Just 287
    (68, 30) -> Just 275
    (68, 31) -> Just 72
    (68, 35) -> Just 271
    (68, 36) -> Just 272
    (68, 40) -> Just 257
    (68, 41) -> Just 258
    (68, 66) -> Just 261
    (69, 8) -> Just 384
    (69, 44) -> Just 62
    (69, 52) -> Just 299
    (69, 66) -> Just 263
    (69, 67) -> Just 300
    (70, 8) -> Just 384
    (70, 31) -> Just 73
    (70, 38) -> Just 279
    (70, 39) -> Just 281
    (70, 66) -> Just 261
    (71, 8) -> Just 384
    (71, 31) -> Just 73
    (71, 38) -> Just 280
    (71, 39) -> Just 281
    (71, 66) -> Just 261
    (72, 8) -> Just 384
    (72, 44) -> Just 62
    (72, 52) -> Just 299
    (72, 66) -> Just 263
    (72, 67) -> Just 300
    (73, 8) -> Just 384
    (73, 44) -> Just 62
    (73, 52) -> Just 299
    (73, 66) -> Just 263
    (73, 67) -> Just 300
    (74, 8) -> Just 384
    (74, 31) -> Just 75
    (74, 66) -> Just 261
    (75, 8) -> Just 384
    (75, 44) -> Just 62
    (75, 52) -> Just 299
    (75, 66) -> Just 263
    (75, 67) -> Just 300
    (76, 8) -> Just 154
    (76, 9) -> Just 155
    (76, 11) -> Just 148
    (76, 12) -> Just 149
    (77, 8) -> Just 154
    (77, 9) -> Just 155
    (77, 11) -> Just 184
    (77, 12) -> Just 149
    (78, 8) -> Just 154
    (78, 9) -> Just 155
    (78, 11) -> Just 185
    (78, 12) -> Just 149
    (79, 8) -> Just 157
    (79, 9) -> Just 158
    (79, 10) -> Just 146
    (79, 13) -> Just 147
    (80, 8) -> Just 157
    (80, 9) -> Just 158
    (80, 10) -> Just 156
    (80, 13) -> Just 147
    (81, 8) -> Just 286
    (81, 40) -> Just 288
    (82, 8) -> Just 286
    (82, 40) -> Just 338
    (82, 53) -> Just 329
    (82, 54) -> Just 336
    (83, 8) -> Just 286
    (83, 40) -> Just 338
    (83, 53) -> Just 335
    (83, 54) -> Just 336
    (84, 8) -> Just 218
    (85, 8) -> Just 229
    (86, 8) -> Just 230
    (87, 8) -> Just 231
    (97, 9) -> Just 315
    (97, 45) -> Just 306
    (97, 46) -> Just 307
    (97, 47) -> Just 308
    (98, 9) -> Just 315
    (98, 17) -> Just 99
    (98, 45) -> Just 209
    (98, 46) -> Just 307
    (98, 47) -> Just 308
    (99, 9) -> Just 315
    (99, 23) -> Just 201
    (99, 45) -> Just 210
    (99, 46) -> Just 307
    (99, 47) -> Just 308
    (100, 9) -> Just 315
    (100, 17) -> Just 101
    (100, 45) -> Just 209
    (100, 46) -> Just 307
    (100, 47) -> Just 308
    (101, 9) -> Just 315
    (101, 24) -> Just 203
    (101, 45) -> Just 210
    (101, 46) -> Just 307
    (101, 47) -> Just 308
    (102, 9) -> Just 315
    (102, 17) -> Just 103
    (102, 45) -> Just 209
    (102, 46) -> Just 307
    (102, 47) -> Just 308
    (103, 9) -> Just 315
    (103, 23) -> Just 200
    (103, 45) -> Just 210
    (103, 46) -> Just 307
    (103, 47) -> Just 308
    (104, 9) -> Just 315
    (104, 17) -> Just 105
    (104, 45) -> Just 209
    (104, 46) -> Just 307
    (104, 47) -> Just 308
    (105, 9) -> Just 315
    (105, 24) -> Just 202
    (105, 45) -> Just 210
    (105, 46) -> Just 307
    (105, 47) -> Just 308
    (106, 9) -> Just 315
    (106, 17) -> Just 107
    (106, 18) -> Just 358
    (106, 45) -> Just 209
    (106, 46) -> Just 307
    (106, 47) -> Just 308
    (107, 9) -> Just 315
    (107, 45) -> Just 210
    (107, 46) -> Just 307
    (107, 47) -> Just 308
    (108, 9) -> Just 315
    (108, 17) -> Just 110
    (108, 18) -> Just 211
    (108, 45) -> Just 209
    (108, 46) -> Just 307
    (108, 47) -> Just 308
    (109, 9) -> Just 315
    (109, 17) -> Just 110
    (109, 18) -> Just 357
    (109, 45) -> Just 209
    (109, 46) -> Just 307
    (109, 47) -> Just 308
    (110, 9) -> Just 315
    (110, 45) -> Just 210
    (110, 46) -> Just 307
    (110, 47) -> Just 308
    (111, 9) -> Just 315
    (111, 17) -> Just 112
    (111, 45) -> Just 209
    (111, 46) -> Just 307
    (111, 47) -> Just 308
    (112, 9) -> Just 315
    (112, 19) -> Just 188
    (112, 45) -> Just 210
    (112, 46) -> Just 307
    (112, 47) -> Just 308
    (113, 9) -> Just 315
    (113, 17) -> Just 114
    (113, 45) -> Just 209
    (113, 46) -> Just 307
    (113, 47) -> Just 308
    (114, 9) -> Just 315
    (114, 19) -> Just 189
    (114, 45) -> Just 210
    (114, 46) -> Just 307
    (114, 47) -> Just 308
    (115, 9) -> Just 316
    (115, 17) -> Just 118
    (115, 45) -> Just 209
    (115, 46) -> Just 307
    (115, 47) -> Just 308
    (115, 50) -> Just 212
    (115, 51) -> Just 326
    (116, 9) -> Just 316
    (116, 17) -> Just 118
    (116, 45) -> Just 209
    (116, 46) -> Just 307
    (116, 47) -> Just 308
    (116, 50) -> Just 325
    (116, 51) -> Just 326
    (117, 9) -> Just 130
    (118, 9) -> Just 315
    (118, 45) -> Just 210
    (118, 46) -> Just 307
    (118, 47) -> Just 308
    (118, 52) -> Just 119
    (119, 9) -> Just 315
    (119, 17) -> Just 120
    (119, 45) -> Just 209
    (119, 46) -> Just 307
    (119, 47) -> Just 308
    (120, 9) -> Just 315
    (120, 45) -> Just 210
    (120, 46) -> Just 307
    (120, 47) -> Just 308
    (121, 9) -> Just 315
    (121, 17) -> Just 122
    (121, 18) -> Just 256
    (121, 45) -> Just 209
    (121, 46) -> Just 307
    (121, 47) -> Just 308
    (122, 9) -> Just 315
    (122, 45) -> Just 210
    (122, 46) -> Just 307
    (122, 47) -> Just 308
    (123, 9) -> Just 315
    (123, 17) -> Just 110
    (123, 18) -> Just 187
    (123, 45) -> Just 209
    (123, 46) -> Just 307
    (123, 47) -> Just 308
    (124, 9) -> Just 315
    (124, 17) -> Just 110
    (124, 18) -> Just 232
    (124, 45) -> Just 209
    (124, 46) -> Just 307
    (124, 47) -> Just 308
    (125, 9) -> Just 315
    (125, 17) -> Just 110
    (125, 18) -> Just 233
    (125, 45) -> Just 209
    (125, 46) -> Just 307
    (125, 47) -> Just 308
    (126, 9) -> Just 315
    (126, 17) -> Just 110
    (126, 18) -> Just 234
    (126, 45) -> Just 209
    (126, 46) -> Just 307
    (126, 47) -> Just 308
    (127, 9) -> Just 315
    (127, 17) -> Just 110
    (127, 18) -> Just 255
    (127, 45) -> Just 209
    (127, 46) -> Just 307
    (127, 47) -> Just 308
    (128, 9) -> Just 315
    (128, 17) -> Just 110
    (128, 18) -> Just 337
    (128, 45) -> Just 209
    (128, 46) -> Just 307
    (128, 47) -> Just 308
    (129, 9) -> Just 315
    (129, 17) -> Just 110
    (129, 18) -> Just 219
    (129, 45) -> Just 209
    (129, 46) -> Just 307
    (129, 47) -> Just 308
    (130, 9) -> Just 315
    (130, 45) -> Just 220
    (130, 46) -> Just 307
    (130, 47) -> Just 308
    (131, 9) -> Just 315
    (131, 17) -> Just 132
    (131, 45) -> Just 209
    (131, 46) -> Just 307
    (131, 47) -> Just 308
    (132, 9) -> Just 315
    (132, 22) -> Just 199
    (132, 45) -> Just 210
    (132, 46) -> Just 307
    (132, 47) -> Just 308
    (133, 9) -> Just 315
    (133, 17) -> Just 135
    (133, 45) -> Just 209
    (133, 46) -> Just 307
    (133, 47) -> Just 308
    (134, 9) -> Just 315
    (134, 17) -> Just 136
    (134, 45) -> Just 209
    (134, 46) -> Just 307
    (134, 47) -> Just 308
    (135, 9) -> Just 315
    (135, 45) -> Just 210
    (135, 46) -> Just 307
    (135, 47) -> Just 308
    (136, 9) -> Just 315
    (136, 22) -> Just 198
    (136, 45) -> Just 210
    (136, 46) -> Just 307
    (136, 47) -> Just 308
    (137, 9) -> Just 315
    (137, 17) -> Just 110
    (137, 18) -> Just 304
    (137, 45) -> Just 209
    (137, 46) -> Just 307
    (137, 47) -> Just 308
    (137, 48) -> Just 309
    (137, 49) -> Just 317
    (138, 9) -> Just 315
    (138, 17) -> Just 110
    (138, 18) -> Just 225
    (138, 25) -> Just 204
    (138, 45) -> Just 209
    (138, 46) -> Just 307
    (138, 47) -> Just 308
    (139, 9) -> Just 315
    (139, 17) -> Just 110
    (139, 18) -> Just 225
    (139, 25) -> Just 226
    (139, 45) -> Just 209
    (139, 46) -> Just 307
    (139, 47) -> Just 308
    (140, 9) -> Just 315
    (140, 17) -> Just 110
    (140, 18) -> Just 321
    (140, 45) -> Just 209
    (140, 46) -> Just 307
    (140, 47) -> Just 308
    (140, 48) -> Just 322
    (141, 9) -> Just 315
    (141, 17) -> Just 110
    (141, 18) -> Just 305
    (141, 45) -> Just 209
    (141, 46) -> Just 307
    (141, 47) -> Just 308
    (159, 20) -> Just 215
    (159, 21) -> Just 194
    (160, 20) -> Just 215
    (160, 21) -> Just 195
    (161, 20) -> Just 215
    (161, 21) -> Just 196
    (162, 20) -> Just 215
    (162, 21) -> Just 197
    (175, 15) -> Just 8
    (177, 20) -> Just 190
    (178, 20) -> Just 191
    (179, 20) -> Just 192
    (180, 20) -> Just 193
    (182, 26) -> Just 205
    (183, 16) -> Just 186
    (213, 20) -> Just 215
    (213, 21) -> Just 216
    (221, 34) -> Just 222
    (223, 37) -> Just 224
    (227, 55) -> Just 235
    (228, 55) -> Just 236
    (235, 56) -> Just 85
    (235, 57) -> Just 237
    (236, 58) -> Just 87
    (237, 56) -> Just 86
    (238, 28) -> Just 240
    (239, 28) -> Just 241
    (245, 28) -> Just 273
    (246, 28) -> Just 274
    (247, 28) -> Just 282
    (248, 28) -> Just 283
    (249, 28) -> Just 349
    (250, 28) -> Just 359
    (258, 42) -> Just 259
    (259, 43) -> Just 260
    (259, 44) -> Just 298
    (259, 52) -> Just 299
    (259, 67) -> Just 300
    (293, 43) -> Just 296
    (293, 44) -> Just 298
    (293, 52) -> Just 299
    (293, 67) -> Just 300
    (294, 43) -> Just 297
    (294, 44) -> Just 298
    (294, 52) -> Just 299
    (294, 67) -> Just 300
    (323, 49) -> Just 324
    (363, 62) -> Just 372
    (364, 62) -> Just 373
    (_, _) -> Nothing

parse :: Monad m => SemanticActions m -> [Token] -> m (Either (Maybe Token) (Module', [Token]))
parse actions = parse' [] where
  parse' stack tokens =
    let p =
          case stack of
            [] -> 0
            ((q, _) : _) -> q in
    let symbol =
          case tokens of
            [] -> EOF
            (token : _) -> Token token in do
      case dfaActionTransition p symbol of
        Nothing ->
          case tokens of
            [] -> return $ Left $ Nothing
            (token : _) -> return $ Left $ Just token
        Just (Shift n) ->
          let value =
                case symbol of
                  EOF ->
                    StackValue_EOF
                  Token (MODULE semanticValue) ->
                    StackValue_MODULE semanticValue
                  Token (WHERE semanticValue) ->
                    StackValue_WHERE semanticValue
                  Token (LBRACE semanticValue) ->
                    StackValue_LBRACE semanticValue
                  Token (RBRACE semanticValue) ->
                    StackValue_RBRACE semanticValue
                  Token (LPAREN semanticValue) ->
                    StackValue_LPAREN semanticValue
                  Token (RPAREN semanticValue) ->
                    StackValue_RPAREN semanticValue
                  Token (COMMA semanticValue) ->
                    StackValue_COMMA semanticValue
                  Token (DOT_DOT semanticValue) ->
                    StackValue_DOT_DOT semanticValue
                  Token (SEMICOLON semanticValue) ->
                    StackValue_SEMICOLON semanticValue
                  Token (IMPORT semanticValue) ->
                    StackValue_IMPORT semanticValue
                  Token (HIDING semanticValue) ->
                    StackValue_HIDING semanticValue
                  Token (TYPE semanticValue) ->
                    StackValue_TYPE semanticValue
                  Token (EQUAL semanticValue) ->
                    StackValue_EQUAL semanticValue
                  Token (DATA semanticValue) ->
                    StackValue_DATA semanticValue
                  Token (DERIVING semanticValue) ->
                    StackValue_DERIVING semanticValue
                  Token (DARROW semanticValue) ->
                    StackValue_DARROW semanticValue
                  Token (NEWTYPE semanticValue) ->
                    StackValue_NEWTYPE semanticValue
                  Token (CLASS semanticValue) ->
                    StackValue_CLASS semanticValue
                  Token (INSTANCE semanticValue) ->
                    StackValue_INSTANCE semanticValue
                  Token (DEFAULT semanticValue) ->
                    StackValue_DEFAULT semanticValue
                  Token (FOREIGN semanticValue) ->
                    StackValue_FOREIGN semanticValue
                  Token (PIPE semanticValue) ->
                    StackValue_PIPE semanticValue
                  Token (COLON_COLON semanticValue) ->
                    StackValue_COLON_COLON semanticValue
                  Token (MINUS semanticValue) ->
                    StackValue_MINUS semanticValue
                  Token (INFIXL semanticValue) ->
                    StackValue_INFIXL semanticValue
                  Token (INFIXR semanticValue) ->
                    StackValue_INFIXR semanticValue
                  Token (INFIX semanticValue) ->
                    StackValue_INFIX semanticValue
                  Token (RARROW semanticValue) ->
                    StackValue_RARROW semanticValue
                  Token (LBRACKET semanticValue) ->
                    StackValue_LBRACKET semanticValue
                  Token (RBRACKET semanticValue) ->
                    StackValue_RBRACKET semanticValue
                  Token (EXCL semanticValue) ->
                    StackValue_EXCL semanticValue
                  Token (QCONID semanticValue) ->
                    StackValue_QCONID semanticValue
                  Token (EXPORT semanticValue) ->
                    StackValue_EXPORT semanticValue
                  Token (AS semanticValue) ->
                    StackValue_AS semanticValue
                  Token (QVARID semanticValue) ->
                    StackValue_QVARID semanticValue
                  Token (STRING semanticValue) ->
                    StackValue_STRING semanticValue
                  Token (LARROW semanticValue) ->
                    StackValue_LARROW semanticValue
                  Token (LET semanticValue) ->
                    StackValue_LET semanticValue
                  Token (LAMBDA semanticValue) ->
                    StackValue_LAMBDA semanticValue
                  Token (IN semanticValue) ->
                    StackValue_IN semanticValue
                  Token (IF semanticValue) ->
                    StackValue_IF semanticValue
                  Token (THEN semanticValue) ->
                    StackValue_THEN semanticValue
                  Token (ELSE semanticValue) ->
                    StackValue_ELSE semanticValue
                  Token (QVARSYM semanticValue) ->
                    StackValue_QVARSYM semanticValue
                  Token (BACKQUOTE semanticValue) ->
                    StackValue_BACKQUOTE semanticValue
                  Token (QCONSYM semanticValue) ->
                    StackValue_QCONSYM semanticValue
                  Token (INTEGER semanticValue) ->
                    StackValue_INTEGER semanticValue
                  Token (QUALIFIED semanticValue) ->
                    StackValue_QUALIFIED semanticValue
          in parse' ((n, value) : stack) (tail tokens)
        Just (Reduce n m) ->
          let (pop, stack') = splitAt n stack in
            case
              case stack' of
                [] -> dfaGotoTransition 0 m
                ((q', _) : _) -> dfaGotoTransition q' m of
              Nothing ->
                case tokens of
                  [] -> return $ Left $ Nothing
                  (token : _) -> return $ Left $ Just token
              Just q -> do
                value <-
                  case m of
                    0 ->
                      Monad.liftM StackValue_module' $ module'_implies_MODULE_modid_exports_opt_WHERE_body actions (case snd (pop !! 4) of { StackValue_MODULE value -> value; _ -> undefined }) (case snd (pop !! 3) of { StackValue_modid value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_exports_opt value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_WHERE value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_body value -> value; _ -> undefined })
                    1 ->
                      Monad.liftM StackValue_module' $ module'_implies_body actions (case snd (pop !! 0) of { StackValue_body value -> value; _ -> undefined })
                    2 ->
                      Monad.liftM StackValue_body $ body_implies_LBRACE_topdecls_RBRACE actions (case snd (pop !! 2) of { StackValue_LBRACE value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_topdecls value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_RBRACE value -> value; _ -> undefined })
                    3 ->
                      Monad.liftM StackValue_exports_opt $ exports_opt_implies actions
                    4 ->
                      Monad.liftM StackValue_exports_opt $ exports_opt_implies_exports actions (case snd (pop !! 0) of { StackValue_exports value -> value; _ -> undefined })
                    5 ->
                      Monad.liftM StackValue_exports $ exports_implies_LPAREN_export_seq_RPAREN actions (case snd (pop !! 2) of { StackValue_LPAREN value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_export_seq value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_RPAREN value -> value; _ -> undefined })
                    6 ->
                      Monad.liftM StackValue_export_seq $ export_seq_implies actions
                    7 ->
                      Monad.liftM StackValue_export_seq $ export_seq_implies_export actions (case snd (pop !! 0) of { StackValue_export value -> value; _ -> undefined })
                    8 ->
                      Monad.liftM StackValue_export_seq $ export_seq_implies_export_COMMA_export_seq actions (case snd (pop !! 2) of { StackValue_export value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_COMMA value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_export_seq value -> value; _ -> undefined })
                    9 ->
                      Monad.liftM StackValue_export $ export_implies_var actions (case snd (pop !! 0) of { StackValue_var value -> value; _ -> undefined })
                    10 ->
                      Monad.liftM StackValue_export $ export_implies_con actions (case snd (pop !! 0) of { StackValue_con value -> value; _ -> undefined })
                    11 ->
                      Monad.liftM StackValue_export $ export_implies_con_LPAREN_RPAREN actions (case snd (pop !! 2) of { StackValue_con value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_LPAREN value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_RPAREN value -> value; _ -> undefined })
                    12 ->
                      Monad.liftM StackValue_export $ export_implies_con_LPAREN_DOT_DOT_RPAREN actions (case snd (pop !! 3) of { StackValue_con value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_LPAREN value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_DOT_DOT value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_RPAREN value -> value; _ -> undefined })
                    13 ->
                      Monad.liftM StackValue_export $ export_implies_con_LPAREN_cname_seq_RPAREN actions (case snd (pop !! 3) of { StackValue_con value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_LPAREN value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_cname_seq value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_RPAREN value -> value; _ -> undefined })
                    14 ->
                      Monad.liftM StackValue_export $ export_implies_MODULE_modid actions (case snd (pop !! 1) of { StackValue_MODULE value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_modid value -> value; _ -> undefined })
                    15 ->
                      Monad.liftM StackValue_import_seq $ import_seq_implies actions
                    16 ->
                      Monad.liftM StackValue_import_seq $ import_seq_implies_import' actions (case snd (pop !! 0) of { StackValue_import' value -> value; _ -> undefined })
                    17 ->
                      Monad.liftM StackValue_import_seq $ import_seq_implies_import'_COMMA_import_seq actions (case snd (pop !! 2) of { StackValue_import' value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_COMMA value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_import_seq value -> value; _ -> undefined })
                    18 ->
                      Monad.liftM StackValue_import' $ import'_implies_var actions (case snd (pop !! 0) of { StackValue_var value -> value; _ -> undefined })
                    19 ->
                      Monad.liftM StackValue_import' $ import'_implies_con actions (case snd (pop !! 0) of { StackValue_con value -> value; _ -> undefined })
                    20 ->
                      Monad.liftM StackValue_import' $ import'_implies_con_LPAREN_RPAREN actions (case snd (pop !! 2) of { StackValue_con value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_LPAREN value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_RPAREN value -> value; _ -> undefined })
                    21 ->
                      Monad.liftM StackValue_import' $ import'_implies_con_LPAREN_DOT_DOT_RPAREN actions (case snd (pop !! 3) of { StackValue_con value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_LPAREN value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_DOT_DOT value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_RPAREN value -> value; _ -> undefined })
                    22 ->
                      Monad.liftM StackValue_import' $ import'_implies_con_LPAREN_cname_seq_RPAREN actions (case snd (pop !! 3) of { StackValue_con value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_LPAREN value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_cname_seq value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_RPAREN value -> value; _ -> undefined })
                    23 ->
                      Monad.liftM StackValue_cname_seq $ cname_seq_implies_cname actions (case snd (pop !! 0) of { StackValue_cname value -> value; _ -> undefined })
                    24 ->
                      Monad.liftM StackValue_cname_seq $ cname_seq_implies_cname_COMMA_cname_seq actions (case snd (pop !! 2) of { StackValue_cname value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_COMMA value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_cname_seq value -> value; _ -> undefined })
                    25 ->
                      Monad.liftM StackValue_cname $ cname_implies_var actions (case snd (pop !! 0) of { StackValue_var value -> value; _ -> undefined })
                    26 ->
                      Monad.liftM StackValue_cname $ cname_implies_con actions (case snd (pop !! 0) of { StackValue_con value -> value; _ -> undefined })
                    27 ->
                      Monad.liftM StackValue_topdecls $ topdecls_implies_topdecl actions (case snd (pop !! 0) of { StackValue_topdecl value -> value; _ -> undefined })
                    28 ->
                      Monad.liftM StackValue_topdecls $ topdecls_implies_topdecl_SEMICOLON_topdecls actions (case snd (pop !! 2) of { StackValue_topdecl value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_SEMICOLON value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_topdecls value -> value; _ -> undefined })
                    29 ->
                      Monad.liftM StackValue_topdecl $ topdecl_implies_IMPORT_qualified_opt_modid_as_opt actions (case snd (pop !! 3) of { StackValue_IMPORT value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_qualified_opt value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_modid value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_as_opt value -> value; _ -> undefined })
                    30 ->
                      Monad.liftM StackValue_topdecl $ topdecl_implies_IMPORT_qualified_opt_modid_as_opt_LPAREN_import_seq_RPAREN actions (case snd (pop !! 6) of { StackValue_IMPORT value -> value; _ -> undefined }) (case snd (pop !! 5) of { StackValue_qualified_opt value -> value; _ -> undefined }) (case snd (pop !! 4) of { StackValue_modid value -> value; _ -> undefined }) (case snd (pop !! 3) of { StackValue_as_opt value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_LPAREN value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_import_seq value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_RPAREN value -> value; _ -> undefined })
                    31 ->
                      Monad.liftM StackValue_topdecl $ topdecl_implies_IMPORT_qualified_opt_modid_as_opt_HIDING_LPAREN_import_seq_RPAREN actions (case snd (pop !! 7) of { StackValue_IMPORT value -> value; _ -> undefined }) (case snd (pop !! 6) of { StackValue_qualified_opt value -> value; _ -> undefined }) (case snd (pop !! 5) of { StackValue_modid value -> value; _ -> undefined }) (case snd (pop !! 4) of { StackValue_as_opt value -> value; _ -> undefined }) (case snd (pop !! 3) of { StackValue_HIDING value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_LPAREN value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_import_seq value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_RPAREN value -> value; _ -> undefined })
                    32 ->
                      Monad.liftM StackValue_topdecl $ topdecl_implies_TYPE_btype_EQUAL_type' actions (case snd (pop !! 3) of { StackValue_TYPE value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_btype value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_EQUAL value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_type' value -> value; _ -> undefined })
                    33 ->
                      Monad.liftM StackValue_topdecl $ topdecl_implies_DATA_btype_constrs_opt actions (case snd (pop !! 2) of { StackValue_DATA value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_btype value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_constrs_opt value -> value; _ -> undefined })
                    34 ->
                      Monad.liftM StackValue_topdecl $ topdecl_implies_DATA_btype_constrs_opt_DERIVING_dclass actions (case snd (pop !! 4) of { StackValue_DATA value -> value; _ -> undefined }) (case snd (pop !! 3) of { StackValue_btype value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_constrs_opt value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_DERIVING value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_dclass value -> value; _ -> undefined })
                    35 ->
                      Monad.liftM StackValue_topdecl $ topdecl_implies_DATA_btype_constrs_opt_DERIVING_LPAREN_RPAREN actions (case snd (pop !! 5) of { StackValue_DATA value -> value; _ -> undefined }) (case snd (pop !! 4) of { StackValue_btype value -> value; _ -> undefined }) (case snd (pop !! 3) of { StackValue_constrs_opt value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_DERIVING value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_LPAREN value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_RPAREN value -> value; _ -> undefined })
                    36 ->
                      Monad.liftM StackValue_topdecl $ topdecl_implies_DATA_btype_constrs_opt_DERIVING_LPAREN_dclass_seq_RPAREN actions (case snd (pop !! 6) of { StackValue_DATA value -> value; _ -> undefined }) (case snd (pop !! 5) of { StackValue_btype value -> value; _ -> undefined }) (case snd (pop !! 4) of { StackValue_constrs_opt value -> value; _ -> undefined }) (case snd (pop !! 3) of { StackValue_DERIVING value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_LPAREN value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_dclass_seq value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_RPAREN value -> value; _ -> undefined })
                    37 ->
                      Monad.liftM StackValue_topdecl $ topdecl_implies_DATA_btype_DARROW_btype_constrs_opt actions (case snd (pop !! 4) of { StackValue_DATA value -> value; _ -> undefined }) (case snd (pop !! 3) of { StackValue_btype value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_DARROW value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_btype value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_constrs_opt value -> value; _ -> undefined })
                    38 ->
                      Monad.liftM StackValue_topdecl $ topdecl_implies_DATA_btype_DARROW_btype_constrs_opt_DERIVING_dclass actions (case snd (pop !! 6) of { StackValue_DATA value -> value; _ -> undefined }) (case snd (pop !! 5) of { StackValue_btype value -> value; _ -> undefined }) (case snd (pop !! 4) of { StackValue_DARROW value -> value; _ -> undefined }) (case snd (pop !! 3) of { StackValue_btype value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_constrs_opt value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_DERIVING value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_dclass value -> value; _ -> undefined })
                    39 ->
                      Monad.liftM StackValue_topdecl $ topdecl_implies_DATA_btype_DARROW_btype_constrs_opt_DERIVING_LPAREN_RPAREN actions (case snd (pop !! 7) of { StackValue_DATA value -> value; _ -> undefined }) (case snd (pop !! 6) of { StackValue_btype value -> value; _ -> undefined }) (case snd (pop !! 5) of { StackValue_DARROW value -> value; _ -> undefined }) (case snd (pop !! 4) of { StackValue_btype value -> value; _ -> undefined }) (case snd (pop !! 3) of { StackValue_constrs_opt value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_DERIVING value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_LPAREN value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_RPAREN value -> value; _ -> undefined })
                    40 ->
                      Monad.liftM StackValue_topdecl $ topdecl_implies_DATA_btype_DARROW_btype_constrs_opt_DERIVING_LPAREN_dclass_seq_RPAREN actions (case snd (pop !! 8) of { StackValue_DATA value -> value; _ -> undefined }) (case snd (pop !! 7) of { StackValue_btype value -> value; _ -> undefined }) (case snd (pop !! 6) of { StackValue_DARROW value -> value; _ -> undefined }) (case snd (pop !! 5) of { StackValue_btype value -> value; _ -> undefined }) (case snd (pop !! 4) of { StackValue_constrs_opt value -> value; _ -> undefined }) (case snd (pop !! 3) of { StackValue_DERIVING value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_LPAREN value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_dclass_seq value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_RPAREN value -> value; _ -> undefined })
                    41 ->
                      Monad.liftM StackValue_topdecl $ topdecl_implies_NEWTYPE_btype_newconstr actions (case snd (pop !! 2) of { StackValue_NEWTYPE value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_btype value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_newconstr value -> value; _ -> undefined })
                    42 ->
                      Monad.liftM StackValue_topdecl $ topdecl_implies_NEWTYPE_btype_newconstr_DERIVING_dclass actions (case snd (pop !! 4) of { StackValue_NEWTYPE value -> value; _ -> undefined }) (case snd (pop !! 3) of { StackValue_btype value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_newconstr value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_DERIVING value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_dclass value -> value; _ -> undefined })
                    43 ->
                      Monad.liftM StackValue_topdecl $ topdecl_implies_NEWTYPE_btype_newconstr_DERIVING_LPAREN_RPAREN actions (case snd (pop !! 5) of { StackValue_NEWTYPE value -> value; _ -> undefined }) (case snd (pop !! 4) of { StackValue_btype value -> value; _ -> undefined }) (case snd (pop !! 3) of { StackValue_newconstr value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_DERIVING value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_LPAREN value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_RPAREN value -> value; _ -> undefined })
                    44 ->
                      Monad.liftM StackValue_topdecl $ topdecl_implies_NEWTYPE_btype_newconstr_DERIVING_LPAREN_dclass_seq_RPAREN actions (case snd (pop !! 6) of { StackValue_NEWTYPE value -> value; _ -> undefined }) (case snd (pop !! 5) of { StackValue_btype value -> value; _ -> undefined }) (case snd (pop !! 4) of { StackValue_newconstr value -> value; _ -> undefined }) (case snd (pop !! 3) of { StackValue_DERIVING value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_LPAREN value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_dclass_seq value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_RPAREN value -> value; _ -> undefined })
                    45 ->
                      Monad.liftM StackValue_topdecl $ topdecl_implies_NEWTYPE_btype_DARROW_btype_newconstr actions (case snd (pop !! 4) of { StackValue_NEWTYPE value -> value; _ -> undefined }) (case snd (pop !! 3) of { StackValue_btype value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_DARROW value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_btype value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_newconstr value -> value; _ -> undefined })
                    46 ->
                      Monad.liftM StackValue_topdecl $ topdecl_implies_NEWTYPE_btype_DARROW_btype_newconstr_DERIVING_dclass actions (case snd (pop !! 6) of { StackValue_NEWTYPE value -> value; _ -> undefined }) (case snd (pop !! 5) of { StackValue_btype value -> value; _ -> undefined }) (case snd (pop !! 4) of { StackValue_DARROW value -> value; _ -> undefined }) (case snd (pop !! 3) of { StackValue_btype value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_newconstr value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_DERIVING value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_dclass value -> value; _ -> undefined })
                    47 ->
                      Monad.liftM StackValue_topdecl $ topdecl_implies_NEWTYPE_btype_DARROW_btype_newconstr_DERIVING_LPAREN_RPAREN actions (case snd (pop !! 7) of { StackValue_NEWTYPE value -> value; _ -> undefined }) (case snd (pop !! 6) of { StackValue_btype value -> value; _ -> undefined }) (case snd (pop !! 5) of { StackValue_DARROW value -> value; _ -> undefined }) (case snd (pop !! 4) of { StackValue_btype value -> value; _ -> undefined }) (case snd (pop !! 3) of { StackValue_newconstr value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_DERIVING value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_LPAREN value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_RPAREN value -> value; _ -> undefined })
                    48 ->
                      Monad.liftM StackValue_topdecl $ topdecl_implies_NEWTYPE_btype_DARROW_btype_newconstr_DERIVING_LPAREN_dclass_seq_RPAREN actions (case snd (pop !! 8) of { StackValue_NEWTYPE value -> value; _ -> undefined }) (case snd (pop !! 7) of { StackValue_btype value -> value; _ -> undefined }) (case snd (pop !! 6) of { StackValue_DARROW value -> value; _ -> undefined }) (case snd (pop !! 5) of { StackValue_btype value -> value; _ -> undefined }) (case snd (pop !! 4) of { StackValue_newconstr value -> value; _ -> undefined }) (case snd (pop !! 3) of { StackValue_DERIVING value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_LPAREN value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_dclass_seq value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_RPAREN value -> value; _ -> undefined })
                    49 ->
                      Monad.liftM StackValue_topdecl $ topdecl_implies_CLASS_btype_cdecls_opt actions (case snd (pop !! 2) of { StackValue_CLASS value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_btype value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_cdecls_opt value -> value; _ -> undefined })
                    50 ->
                      Monad.liftM StackValue_topdecl $ topdecl_implies_CLASS_btype_DARROW_btype_cdecls_opt actions (case snd (pop !! 4) of { StackValue_CLASS value -> value; _ -> undefined }) (case snd (pop !! 3) of { StackValue_btype value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_DARROW value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_btype value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_cdecls_opt value -> value; _ -> undefined })
                    51 ->
                      Monad.liftM StackValue_topdecl $ topdecl_implies_INSTANCE_btype_idecls_opt actions (case snd (pop !! 2) of { StackValue_INSTANCE value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_btype value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_idecls_opt value -> value; _ -> undefined })
                    52 ->
                      Monad.liftM StackValue_topdecl $ topdecl_implies_INSTANCE_btype_DARROW_btype_idecls_opt actions (case snd (pop !! 4) of { StackValue_INSTANCE value -> value; _ -> undefined }) (case snd (pop !! 3) of { StackValue_btype value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_DARROW value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_btype value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_idecls_opt value -> value; _ -> undefined })
                    53 ->
                      Monad.liftM StackValue_topdecl $ topdecl_implies_DEFAULT_LPAREN_RPAREN actions (case snd (pop !! 2) of { StackValue_DEFAULT value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_LPAREN value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_RPAREN value -> value; _ -> undefined })
                    54 ->
                      Monad.liftM StackValue_topdecl $ topdecl_implies_DEFAULT_LPAREN_type_seq_RPAREN actions (case snd (pop !! 3) of { StackValue_DEFAULT value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_LPAREN value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_type_seq value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_RPAREN value -> value; _ -> undefined })
                    55 ->
                      Monad.liftM StackValue_topdecl $ topdecl_implies_FOREIGN_fdecl actions (case snd (pop !! 1) of { StackValue_FOREIGN value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_fdecl value -> value; _ -> undefined })
                    56 ->
                      Monad.liftM StackValue_topdecl $ topdecl_implies_decl actions (case snd (pop !! 0) of { StackValue_decl value -> value; _ -> undefined })
                    57 ->
                      Monad.liftM StackValue_decls $ decls_implies_LBRACE_decl_seq_RBRACE actions (case snd (pop !! 2) of { StackValue_LBRACE value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_decl_seq value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_RBRACE value -> value; _ -> undefined })
                    58 ->
                      Monad.liftM StackValue_decl_seq $ decl_seq_implies_decl actions (case snd (pop !! 0) of { StackValue_decl value -> value; _ -> undefined })
                    59 ->
                      Monad.liftM StackValue_decl_seq $ decl_seq_implies_decl_SEMICOLON_decl_seq actions (case snd (pop !! 2) of { StackValue_decl value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_SEMICOLON value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_decl_seq value -> value; _ -> undefined })
                    60 ->
                      Monad.liftM StackValue_decl $ decl_implies_gendecl actions (case snd (pop !! 0) of { StackValue_gendecl value -> value; _ -> undefined })
                    61 ->
                      Monad.liftM StackValue_decl $ decl_implies_pat_EQUAL_exp actions (case snd (pop !! 2) of { StackValue_pat value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_EQUAL value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_exp value -> value; _ -> undefined })
                    62 ->
                      Monad.liftM StackValue_decl $ decl_implies_pat_EQUAL_exp_WHERE_decls actions (case snd (pop !! 4) of { StackValue_pat value -> value; _ -> undefined }) (case snd (pop !! 3) of { StackValue_EQUAL value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_exp value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_WHERE value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_decls value -> value; _ -> undefined })
                    63 ->
                      Monad.liftM StackValue_decl $ decl_implies_pat_PIPE_gdrhs actions (case snd (pop !! 2) of { StackValue_pat value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_PIPE value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_gdrhs value -> value; _ -> undefined })
                    64 ->
                      Monad.liftM StackValue_decl $ decl_implies_pat_PIPE_gdrhs_WHERE_decls actions (case snd (pop !! 4) of { StackValue_pat value -> value; _ -> undefined }) (case snd (pop !! 3) of { StackValue_PIPE value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_gdrhs value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_WHERE value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_decls value -> value; _ -> undefined })
                    65 ->
                      Monad.liftM StackValue_cdecls_opt $ cdecls_opt_implies actions
                    66 ->
                      Monad.liftM StackValue_cdecls_opt $ cdecls_opt_implies_WHERE_cdecls actions (case snd (pop !! 1) of { StackValue_WHERE value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_cdecls value -> value; _ -> undefined })
                    67 ->
                      Monad.liftM StackValue_cdecls $ cdecls_implies_LBRACE_cdecl_seq_RBRACE actions (case snd (pop !! 2) of { StackValue_LBRACE value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_cdecl_seq value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_RBRACE value -> value; _ -> undefined })
                    68 ->
                      Monad.liftM StackValue_cdecl_seq $ cdecl_seq_implies_cdecl actions (case snd (pop !! 0) of { StackValue_cdecl value -> value; _ -> undefined })
                    69 ->
                      Monad.liftM StackValue_cdecl_seq $ cdecl_seq_implies_cdecl_SEMICOLON_cdecl_seq actions (case snd (pop !! 2) of { StackValue_cdecl value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_SEMICOLON value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_cdecl_seq value -> value; _ -> undefined })
                    70 ->
                      Monad.liftM StackValue_cdecl $ cdecl_implies_gendecl actions (case snd (pop !! 0) of { StackValue_gendecl value -> value; _ -> undefined })
                    71 ->
                      Monad.liftM StackValue_cdecl $ cdecl_implies_pat_EQUAL_exp actions (case snd (pop !! 2) of { StackValue_pat value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_EQUAL value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_exp value -> value; _ -> undefined })
                    72 ->
                      Monad.liftM StackValue_cdecl $ cdecl_implies_pat_EQUAL_exp_WHERE_decls actions (case snd (pop !! 4) of { StackValue_pat value -> value; _ -> undefined }) (case snd (pop !! 3) of { StackValue_EQUAL value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_exp value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_WHERE value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_decls value -> value; _ -> undefined })
                    73 ->
                      Monad.liftM StackValue_cdecl $ cdecl_implies_pat_PIPE_gdrhs actions (case snd (pop !! 2) of { StackValue_pat value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_PIPE value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_gdrhs value -> value; _ -> undefined })
                    74 ->
                      Monad.liftM StackValue_cdecl $ cdecl_implies_pat_PIPE_gdrhs_WHERE_decls actions (case snd (pop !! 4) of { StackValue_pat value -> value; _ -> undefined }) (case snd (pop !! 3) of { StackValue_PIPE value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_gdrhs value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_WHERE value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_decls value -> value; _ -> undefined })
                    75 ->
                      Monad.liftM StackValue_idecls_opt $ idecls_opt_implies actions
                    76 ->
                      Monad.liftM StackValue_idecls_opt $ idecls_opt_implies_WHERE_idecls actions (case snd (pop !! 1) of { StackValue_WHERE value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_idecls value -> value; _ -> undefined })
                    77 ->
                      Monad.liftM StackValue_idecls $ idecls_implies_LBRACE_idecl_seq_RBRACE actions (case snd (pop !! 2) of { StackValue_LBRACE value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_idecl_seq value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_RBRACE value -> value; _ -> undefined })
                    78 ->
                      Monad.liftM StackValue_idecl_seq $ idecl_seq_implies_idecl actions (case snd (pop !! 0) of { StackValue_idecl value -> value; _ -> undefined })
                    79 ->
                      Monad.liftM StackValue_idecl_seq $ idecl_seq_implies_idecl_SEMICOLON_idecl_seq actions (case snd (pop !! 2) of { StackValue_idecl value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_SEMICOLON value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_idecl_seq value -> value; _ -> undefined })
                    80 ->
                      Monad.liftM StackValue_idecl $ idecl_implies actions
                    81 ->
                      Monad.liftM StackValue_idecl $ idecl_implies_pat_EQUAL_exp actions (case snd (pop !! 2) of { StackValue_pat value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_EQUAL value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_exp value -> value; _ -> undefined })
                    82 ->
                      Monad.liftM StackValue_idecl $ idecl_implies_pat_EQUAL_exp_WHERE_decls actions (case snd (pop !! 4) of { StackValue_pat value -> value; _ -> undefined }) (case snd (pop !! 3) of { StackValue_EQUAL value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_exp value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_WHERE value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_decls value -> value; _ -> undefined })
                    83 ->
                      Monad.liftM StackValue_idecl $ idecl_implies_pat_PIPE_gdrhs actions (case snd (pop !! 2) of { StackValue_pat value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_PIPE value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_gdrhs value -> value; _ -> undefined })
                    84 ->
                      Monad.liftM StackValue_idecl $ idecl_implies_pat_PIPE_gdrhs_WHERE_decls actions (case snd (pop !! 4) of { StackValue_pat value -> value; _ -> undefined }) (case snd (pop !! 3) of { StackValue_PIPE value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_gdrhs value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_WHERE value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_decls value -> value; _ -> undefined })
                    85 ->
                      Monad.liftM StackValue_gendecl $ gendecl_implies actions
                    86 ->
                      Monad.liftM StackValue_gendecl $ gendecl_implies_vars_COLON_COLON_type' actions (case snd (pop !! 2) of { StackValue_vars value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_COLON_COLON value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_type' value -> value; _ -> undefined })
                    87 ->
                      Monad.liftM StackValue_gendecl $ gendecl_implies_vars_COLON_COLON_btype_DARROW_type' actions (case snd (pop !! 4) of { StackValue_vars value -> value; _ -> undefined }) (case snd (pop !! 3) of { StackValue_COLON_COLON value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_btype value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_DARROW value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_type' value -> value; _ -> undefined })
                    88 ->
                      Monad.liftM StackValue_gendecl $ gendecl_implies_fixity_integer_opt_ops actions (case snd (pop !! 2) of { StackValue_fixity value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_integer_opt value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_ops value -> value; _ -> undefined })
                    89 ->
                      Monad.liftM StackValue_ops $ ops_implies_MINUS actions (case snd (pop !! 0) of { StackValue_MINUS value -> value; _ -> undefined })
                    90 ->
                      Monad.liftM StackValue_ops $ ops_implies_op actions (case snd (pop !! 0) of { StackValue_op value -> value; _ -> undefined })
                    91 ->
                      Monad.liftM StackValue_ops $ ops_implies_MINUS_COMMA_ops actions (case snd (pop !! 2) of { StackValue_MINUS value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_COMMA value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_ops value -> value; _ -> undefined })
                    92 ->
                      Monad.liftM StackValue_ops $ ops_implies_op_COMMA_ops actions (case snd (pop !! 2) of { StackValue_op value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_COMMA value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_ops value -> value; _ -> undefined })
                    93 ->
                      Monad.liftM StackValue_vars $ vars_implies_var actions (case snd (pop !! 0) of { StackValue_var value -> value; _ -> undefined })
                    94 ->
                      Monad.liftM StackValue_vars $ vars_implies_var_COMMA_vars actions (case snd (pop !! 2) of { StackValue_var value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_COMMA value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_vars value -> value; _ -> undefined })
                    95 ->
                      Monad.liftM StackValue_fixity $ fixity_implies_INFIXL actions (case snd (pop !! 0) of { StackValue_INFIXL value -> value; _ -> undefined })
                    96 ->
                      Monad.liftM StackValue_fixity $ fixity_implies_INFIXR actions (case snd (pop !! 0) of { StackValue_INFIXR value -> value; _ -> undefined })
                    97 ->
                      Monad.liftM StackValue_fixity $ fixity_implies_INFIX actions (case snd (pop !! 0) of { StackValue_INFIX value -> value; _ -> undefined })
                    98 ->
                      Monad.liftM StackValue_type_seq $ type_seq_implies_type' actions (case snd (pop !! 0) of { StackValue_type' value -> value; _ -> undefined })
                    99 ->
                      Monad.liftM StackValue_type_seq $ type_seq_implies_type'_COMMA_type_seq actions (case snd (pop !! 2) of { StackValue_type' value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_COMMA value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_type_seq value -> value; _ -> undefined })
                    100 ->
                      Monad.liftM StackValue_type' $ type'_implies_btype actions (case snd (pop !! 0) of { StackValue_btype value -> value; _ -> undefined })
                    101 ->
                      Monad.liftM StackValue_type' $ type'_implies_btype_RARROW_type' actions (case snd (pop !! 2) of { StackValue_btype value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_RARROW value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_type' value -> value; _ -> undefined })
                    102 ->
                      Monad.liftM StackValue_btype $ btype_implies_atype actions (case snd (pop !! 0) of { StackValue_atype value -> value; _ -> undefined })
                    103 ->
                      Monad.liftM StackValue_btype $ btype_implies_btype_atype actions (case snd (pop !! 1) of { StackValue_btype value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_atype value -> value; _ -> undefined })
                    104 ->
                      Monad.liftM StackValue_atype $ atype_implies_gtycon actions (case snd (pop !! 0) of { StackValue_gtycon value -> value; _ -> undefined })
                    105 ->
                      Monad.liftM StackValue_atype $ atype_implies_tyvar actions (case snd (pop !! 0) of { StackValue_tyvar value -> value; _ -> undefined })
                    106 ->
                      Monad.liftM StackValue_atype $ atype_implies_LPAREN_type_seq2_RPAREN actions (case snd (pop !! 2) of { StackValue_LPAREN value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_type_seq2 value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_RPAREN value -> value; _ -> undefined })
                    107 ->
                      Monad.liftM StackValue_atype $ atype_implies_LBRACKET_type'_RBRACKET actions (case snd (pop !! 2) of { StackValue_LBRACKET value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_type' value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_RBRACKET value -> value; _ -> undefined })
                    108 ->
                      Monad.liftM StackValue_atype $ atype_implies_LPAREN_type'_RPAREN actions (case snd (pop !! 2) of { StackValue_LPAREN value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_type' value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_RPAREN value -> value; _ -> undefined })
                    109 ->
                      Monad.liftM StackValue_atype $ atype_implies_EXCL_atype actions (case snd (pop !! 1) of { StackValue_EXCL value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_atype value -> value; _ -> undefined })
                    110 ->
                      Monad.liftM StackValue_type_seq2 $ type_seq2_implies_type'_COMMA_type' actions (case snd (pop !! 2) of { StackValue_type' value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_COMMA value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_type' value -> value; _ -> undefined })
                    111 ->
                      Monad.liftM StackValue_type_seq2 $ type_seq2_implies_type'_COMMA_type_seq2 actions (case snd (pop !! 2) of { StackValue_type' value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_COMMA value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_type_seq2 value -> value; _ -> undefined })
                    112 ->
                      Monad.liftM StackValue_gtycon $ gtycon_implies_con actions (case snd (pop !! 0) of { StackValue_con value -> value; _ -> undefined })
                    113 ->
                      Monad.liftM StackValue_gtycon $ gtycon_implies_LPAREN_RPAREN actions (case snd (pop !! 1) of { StackValue_LPAREN value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_RPAREN value -> value; _ -> undefined })
                    114 ->
                      Monad.liftM StackValue_gtycon $ gtycon_implies_LBRACKET_RBRACKET actions (case snd (pop !! 1) of { StackValue_LBRACKET value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_RBRACKET value -> value; _ -> undefined })
                    115 ->
                      Monad.liftM StackValue_gtycon $ gtycon_implies_LPAREN_RARROW_RPAREN actions (case snd (pop !! 2) of { StackValue_LPAREN value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_RARROW value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_RPAREN value -> value; _ -> undefined })
                    116 ->
                      Monad.liftM StackValue_gtycon $ gtycon_implies_LPAREN_comma_list_RPAREN actions (case snd (pop !! 2) of { StackValue_LPAREN value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_comma_list value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_RPAREN value -> value; _ -> undefined })
                    117 ->
                      Monad.liftM StackValue_comma_list $ comma_list_implies_COMMA actions (case snd (pop !! 0) of { StackValue_COMMA value -> value; _ -> undefined })
                    118 ->
                      Monad.liftM StackValue_comma_list $ comma_list_implies_COMMA_comma_list actions (case snd (pop !! 1) of { StackValue_COMMA value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_comma_list value -> value; _ -> undefined })
                    119 ->
                      Monad.liftM StackValue_constrs_opt $ constrs_opt_implies actions
                    120 ->
                      Monad.liftM StackValue_constrs_opt $ constrs_opt_implies_EQUAL_constrs actions (case snd (pop !! 1) of { StackValue_EQUAL value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_constrs value -> value; _ -> undefined })
                    121 ->
                      Monad.liftM StackValue_constrs $ constrs_implies_constr actions (case snd (pop !! 0) of { StackValue_constr value -> value; _ -> undefined })
                    122 ->
                      Monad.liftM StackValue_constrs $ constrs_implies_constr_PIPE_constrs actions (case snd (pop !! 2) of { StackValue_constr value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_PIPE value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_constrs value -> value; _ -> undefined })
                    123 ->
                      Monad.liftM StackValue_constr $ constr_implies_btype actions (case snd (pop !! 0) of { StackValue_btype value -> value; _ -> undefined })
                    124 ->
                      Monad.liftM StackValue_constr $ constr_implies_btype_conop_btype actions (case snd (pop !! 2) of { StackValue_btype value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_conop value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_btype value -> value; _ -> undefined })
                    125 ->
                      Monad.liftM StackValue_constr $ constr_implies_con_LBRACE_RBRACE actions (case snd (pop !! 2) of { StackValue_con value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_LBRACE value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_RBRACE value -> value; _ -> undefined })
                    126 ->
                      Monad.liftM StackValue_constr $ constr_implies_con_LBRACE_fielddecl_seq_RBRACE actions (case snd (pop !! 3) of { StackValue_con value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_LBRACE value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_fielddecl_seq value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_RBRACE value -> value; _ -> undefined })
                    127 ->
                      Monad.liftM StackValue_newconstr $ newconstr_implies_EQUAL_con_atype actions (case snd (pop !! 2) of { StackValue_EQUAL value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_con value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_atype value -> value; _ -> undefined })
                    128 ->
                      Monad.liftM StackValue_newconstr $ newconstr_implies_EQUAL_con_LBRACE_var_COLON_COLON_type'_RBRACE actions (case snd (pop !! 6) of { StackValue_EQUAL value -> value; _ -> undefined }) (case snd (pop !! 5) of { StackValue_con value -> value; _ -> undefined }) (case snd (pop !! 4) of { StackValue_LBRACE value -> value; _ -> undefined }) (case snd (pop !! 3) of { StackValue_var value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_COLON_COLON value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_type' value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_RBRACE value -> value; _ -> undefined })
                    129 ->
                      Monad.liftM StackValue_fielddecl_seq $ fielddecl_seq_implies_fielddecl actions (case snd (pop !! 0) of { StackValue_fielddecl value -> value; _ -> undefined })
                    130 ->
                      Monad.liftM StackValue_fielddecl_seq $ fielddecl_seq_implies_fielddecl_COMMA_fielddecl_seq actions (case snd (pop !! 2) of { StackValue_fielddecl value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_COMMA value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_fielddecl_seq value -> value; _ -> undefined })
                    131 ->
                      Monad.liftM StackValue_fielddecl $ fielddecl_implies_vars_COLON_COLON_type' actions (case snd (pop !! 2) of { StackValue_vars value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_COLON_COLON value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_type' value -> value; _ -> undefined })
                    132 ->
                      Monad.liftM StackValue_dclass_seq $ dclass_seq_implies_dclass actions (case snd (pop !! 0) of { StackValue_dclass value -> value; _ -> undefined })
                    133 ->
                      Monad.liftM StackValue_dclass_seq $ dclass_seq_implies_dclass_COMMA_dclass_seq actions (case snd (pop !! 2) of { StackValue_dclass value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_COMMA value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_dclass_seq value -> value; _ -> undefined })
                    134 ->
                      Monad.liftM StackValue_dclass $ dclass_implies_QCONID actions (case snd (pop !! 0) of { StackValue_QCONID value -> value; _ -> undefined })
                    135 ->
                      Monad.liftM StackValue_fdecl $ fdecl_implies_IMPORT_callconv_impent_var_COLON_COLON_type' actions (case snd (pop !! 5) of { StackValue_IMPORT value -> value; _ -> undefined }) (case snd (pop !! 4) of { StackValue_callconv value -> value; _ -> undefined }) (case snd (pop !! 3) of { StackValue_impent value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_var value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_COLON_COLON value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_type' value -> value; _ -> undefined })
                    136 ->
                      Monad.liftM StackValue_fdecl $ fdecl_implies_IMPORT_callconv_safety_impent_var_COLON_COLON_type' actions (case snd (pop !! 6) of { StackValue_IMPORT value -> value; _ -> undefined }) (case snd (pop !! 5) of { StackValue_callconv value -> value; _ -> undefined }) (case snd (pop !! 4) of { StackValue_safety value -> value; _ -> undefined }) (case snd (pop !! 3) of { StackValue_impent value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_var value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_COLON_COLON value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_type' value -> value; _ -> undefined })
                    137 ->
                      Monad.liftM StackValue_fdecl $ fdecl_implies_EXPORT_callconv_expent_var_COLON_COLON_type' actions (case snd (pop !! 5) of { StackValue_EXPORT value -> value; _ -> undefined }) (case snd (pop !! 4) of { StackValue_callconv value -> value; _ -> undefined }) (case snd (pop !! 3) of { StackValue_expent value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_var value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_COLON_COLON value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_type' value -> value; _ -> undefined })
                    138 ->
                      Monad.liftM StackValue_callconv $ callconv_implies_AS actions (case snd (pop !! 0) of { StackValue_AS value -> value; _ -> undefined })
                    139 ->
                      Monad.liftM StackValue_callconv $ callconv_implies_EXPORT actions (case snd (pop !! 0) of { StackValue_EXPORT value -> value; _ -> undefined })
                    140 ->
                      Monad.liftM StackValue_callconv $ callconv_implies_QVARID actions (case snd (pop !! 0) of { StackValue_QVARID value -> value; _ -> undefined })
                    141 ->
                      Monad.liftM StackValue_impent $ impent_implies_STRING actions (case snd (pop !! 0) of { StackValue_STRING value -> value; _ -> undefined })
                    142 ->
                      Monad.liftM StackValue_expent $ expent_implies_STRING actions (case snd (pop !! 0) of { StackValue_STRING value -> value; _ -> undefined })
                    143 ->
                      Monad.liftM StackValue_safety $ safety_implies_AS actions (case snd (pop !! 0) of { StackValue_AS value -> value; _ -> undefined })
                    144 ->
                      Monad.liftM StackValue_safety $ safety_implies_EXPORT actions (case snd (pop !! 0) of { StackValue_EXPORT value -> value; _ -> undefined })
                    145 ->
                      Monad.liftM StackValue_safety $ safety_implies_QVARID actions (case snd (pop !! 0) of { StackValue_QVARID value -> value; _ -> undefined })
                    146 ->
                      Monad.liftM StackValue_gdrhs $ gdrhs_implies_guards_EQUAL_exp actions (case snd (pop !! 2) of { StackValue_guards value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_EQUAL value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_exp value -> value; _ -> undefined })
                    147 ->
                      Monad.liftM StackValue_gdrhs $ gdrhs_implies_guards_EQUAL_exp_PIPE_gdrhs actions (case snd (pop !! 4) of { StackValue_guards value -> value; _ -> undefined }) (case snd (pop !! 3) of { StackValue_EQUAL value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_exp value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_PIPE value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_gdrhs value -> value; _ -> undefined })
                    148 ->
                      Monad.liftM StackValue_guards $ guards_implies_guard actions (case snd (pop !! 0) of { StackValue_guard value -> value; _ -> undefined })
                    149 ->
                      Monad.liftM StackValue_guards $ guards_implies_guard_COMMA_guards actions (case snd (pop !! 2) of { StackValue_guard value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_COMMA value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_guards value -> value; _ -> undefined })
                    150 ->
                      Monad.liftM StackValue_guard $ guard_implies_infixexp_LARROW_exp actions (case snd (pop !! 2) of { StackValue_infixexp value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_LARROW value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_exp value -> value; _ -> undefined })
                    151 ->
                      Monad.liftM StackValue_guard $ guard_implies_LET_decls actions (case snd (pop !! 1) of { StackValue_LET value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_decls value -> value; _ -> undefined })
                    152 ->
                      Monad.liftM StackValue_guard $ guard_implies_infixexp actions (case snd (pop !! 0) of { StackValue_infixexp value -> value; _ -> undefined })
                    153 ->
                      Monad.liftM StackValue_exp $ exp_implies_infixexp actions (case snd (pop !! 0) of { StackValue_infixexp value -> value; _ -> undefined })
                    154 ->
                      Monad.liftM StackValue_infixexp $ infixexp_implies_LAMBDA_pat_RARROW_exp actions (case snd (pop !! 3) of { StackValue_LAMBDA value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_pat value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_RARROW value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_exp value -> value; _ -> undefined })
                    155 ->
                      Monad.liftM StackValue_infixexp $ infixexp_implies_LET_decls_IN_exp actions (case snd (pop !! 3) of { StackValue_LET value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_decls value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_IN value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_exp value -> value; _ -> undefined })
                    156 ->
                      Monad.liftM StackValue_infixexp $ infixexp_implies_IF_exp_semicolon_opt_THEN_exp_semicolon_opt_ELSE_exp actions (case snd (pop !! 7) of { StackValue_IF value -> value; _ -> undefined }) (case snd (pop !! 6) of { StackValue_exp value -> value; _ -> undefined }) (case snd (pop !! 5) of { StackValue_semicolon_opt value -> value; _ -> undefined }) (case snd (pop !! 4) of { StackValue_THEN value -> value; _ -> undefined }) (case snd (pop !! 3) of { StackValue_exp value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_semicolon_opt value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_ELSE value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_exp value -> value; _ -> undefined })
                    157 ->
                      Monad.liftM StackValue_infixexp $ infixexp_implies_lexp_MINUS_exp actions (case snd (pop !! 2) of { StackValue_lexp value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_MINUS value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_exp value -> value; _ -> undefined })
                    158 ->
                      Monad.liftM StackValue_infixexp $ infixexp_implies_lexp_QVARSYM_exp actions (case snd (pop !! 2) of { StackValue_lexp value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_QVARSYM value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_exp value -> value; _ -> undefined })
                    159 ->
                      Monad.liftM StackValue_infixexp $ infixexp_implies_lexp_BACKQUOTE_AS_BACKQUOTE_exp actions (case snd (pop !! 4) of { StackValue_lexp value -> value; _ -> undefined }) (case snd (pop !! 3) of { StackValue_BACKQUOTE value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_AS value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_BACKQUOTE value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_exp value -> value; _ -> undefined })
                    160 ->
                      Monad.liftM StackValue_infixexp $ infixexp_implies_lexp_BACKQUOTE_EXPORT_BACKQUOTE_exp actions (case snd (pop !! 4) of { StackValue_lexp value -> value; _ -> undefined }) (case snd (pop !! 3) of { StackValue_BACKQUOTE value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_EXPORT value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_BACKQUOTE value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_exp value -> value; _ -> undefined })
                    161 ->
                      Monad.liftM StackValue_infixexp $ infixexp_implies_lexp_BACKQUOTE_QVARID_BACKQUOTE_exp actions (case snd (pop !! 4) of { StackValue_lexp value -> value; _ -> undefined }) (case snd (pop !! 3) of { StackValue_BACKQUOTE value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_QVARID value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_BACKQUOTE value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_exp value -> value; _ -> undefined })
                    162 ->
                      Monad.liftM StackValue_infixexp $ infixexp_implies_lexp_QCONSYM_exp actions (case snd (pop !! 2) of { StackValue_lexp value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_QCONSYM value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_exp value -> value; _ -> undefined })
                    163 ->
                      Monad.liftM StackValue_infixexp $ infixexp_implies_lexp_BACKQUOTE_QCONID_BACKQUOTE_exp actions (case snd (pop !! 4) of { StackValue_lexp value -> value; _ -> undefined }) (case snd (pop !! 3) of { StackValue_BACKQUOTE value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_QCONID value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_BACKQUOTE value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_exp value -> value; _ -> undefined })
                    164 ->
                      Monad.liftM StackValue_infixexp $ infixexp_implies_lexp_COLON_COLON_type' actions (case snd (pop !! 2) of { StackValue_lexp value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_COLON_COLON value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_type' value -> value; _ -> undefined })
                    165 ->
                      Monad.liftM StackValue_infixexp $ infixexp_implies_lexp_COLON_COLON_btype_DARROW_type' actions (case snd (pop !! 4) of { StackValue_lexp value -> value; _ -> undefined }) (case snd (pop !! 3) of { StackValue_COLON_COLON value -> value; _ -> undefined }) (case snd (pop !! 2) of { StackValue_btype value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_DARROW value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_type' value -> value; _ -> undefined })
                    166 ->
                      Monad.liftM StackValue_infixexp $ infixexp_implies_lexp actions (case snd (pop !! 0) of { StackValue_lexp value -> value; _ -> undefined })
                    167 ->
                      Monad.liftM StackValue_lexp $ lexp_implies_MINUS_fexp actions (case snd (pop !! 1) of { StackValue_MINUS value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_fexp value -> value; _ -> undefined })
                    168 ->
                      Monad.liftM StackValue_lexp $ lexp_implies_fexp actions (case snd (pop !! 0) of { StackValue_fexp value -> value; _ -> undefined })
                    169 ->
                      Monad.liftM StackValue_fexp $ fexp_implies_aexp actions (case snd (pop !! 0) of { StackValue_aexp value -> value; _ -> undefined })
                    170 ->
                      Monad.liftM StackValue_fexp $ fexp_implies_fexp_aexp actions (case snd (pop !! 1) of { StackValue_fexp value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_aexp value -> value; _ -> undefined })
                    171 ->
                      Monad.liftM StackValue_aexp $ aexp_implies_var actions (case snd (pop !! 0) of { StackValue_var value -> value; _ -> undefined })
                    172 ->
                      Monad.liftM StackValue_aexp $ aexp_implies_INTEGER actions (case snd (pop !! 0) of { StackValue_INTEGER value -> value; _ -> undefined })
                    173 ->
                      Monad.liftM StackValue_aexp $ aexp_implies_STRING actions (case snd (pop !! 0) of { StackValue_STRING value -> value; _ -> undefined })
                    174 ->
                      Monad.liftM StackValue_aexp $ aexp_implies_LPAREN_exp_RPAREN actions (case snd (pop !! 2) of { StackValue_LPAREN value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_exp value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_RPAREN value -> value; _ -> undefined })
                    175 ->
                      Monad.liftM StackValue_pat $ pat_implies_apat actions (case snd (pop !! 0) of { StackValue_apat value -> value; _ -> undefined })
                    176 ->
                      Monad.liftM StackValue_pat $ pat_implies_pat_apat actions (case snd (pop !! 1) of { StackValue_pat value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_apat value -> value; _ -> undefined })
                    177 ->
                      Monad.liftM StackValue_pat $ pat_implies_pat_MINUS_apat actions (case snd (pop !! 2) of { StackValue_pat value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_MINUS value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_apat value -> value; _ -> undefined })
                    178 ->
                      Monad.liftM StackValue_pat $ pat_implies_pat_op_apat actions (case snd (pop !! 2) of { StackValue_pat value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_op value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_apat value -> value; _ -> undefined })
                    179 ->
                      Monad.liftM StackValue_apat $ apat_implies_var actions (case snd (pop !! 0) of { StackValue_var value -> value; _ -> undefined })
                    180 ->
                      Monad.liftM StackValue_apat $ apat_implies_LPAREN_pat_RPAREN actions (case snd (pop !! 2) of { StackValue_LPAREN value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_pat value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_RPAREN value -> value; _ -> undefined })
                    181 ->
                      Monad.liftM StackValue_var $ var_implies_AS actions (case snd (pop !! 0) of { StackValue_AS value -> value; _ -> undefined })
                    182 ->
                      Monad.liftM StackValue_var $ var_implies_EXPORT actions (case snd (pop !! 0) of { StackValue_EXPORT value -> value; _ -> undefined })
                    183 ->
                      Monad.liftM StackValue_var $ var_implies_QVARID actions (case snd (pop !! 0) of { StackValue_QVARID value -> value; _ -> undefined })
                    184 ->
                      Monad.liftM StackValue_var $ var_implies_LPAREN_MINUS_RPAREN actions (case snd (pop !! 2) of { StackValue_LPAREN value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_MINUS value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_RPAREN value -> value; _ -> undefined })
                    185 ->
                      Monad.liftM StackValue_var $ var_implies_LPAREN_QVARSYM_RPAREN actions (case snd (pop !! 2) of { StackValue_LPAREN value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_QVARSYM value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_RPAREN value -> value; _ -> undefined })
                    186 ->
                      Monad.liftM StackValue_con $ con_implies_QCONID actions (case snd (pop !! 0) of { StackValue_QCONID value -> value; _ -> undefined })
                    187 ->
                      Monad.liftM StackValue_con $ con_implies_LPAREN_QCONSYM_RPAREN actions (case snd (pop !! 2) of { StackValue_LPAREN value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_QCONSYM value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_RPAREN value -> value; _ -> undefined })
                    188 ->
                      Monad.liftM StackValue_varop $ varop_implies_QVARSYM actions (case snd (pop !! 0) of { StackValue_QVARSYM value -> value; _ -> undefined })
                    189 ->
                      Monad.liftM StackValue_varop $ varop_implies_BACKQUOTE_AS_BACKQUOTE actions (case snd (pop !! 2) of { StackValue_BACKQUOTE value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_AS value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_BACKQUOTE value -> value; _ -> undefined })
                    190 ->
                      Monad.liftM StackValue_varop $ varop_implies_BACKQUOTE_EXPORT_BACKQUOTE actions (case snd (pop !! 2) of { StackValue_BACKQUOTE value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_EXPORT value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_BACKQUOTE value -> value; _ -> undefined })
                    191 ->
                      Monad.liftM StackValue_varop $ varop_implies_BACKQUOTE_QVARID_BACKQUOTE actions (case snd (pop !! 2) of { StackValue_BACKQUOTE value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_QVARID value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_BACKQUOTE value -> value; _ -> undefined })
                    192 ->
                      Monad.liftM StackValue_conop $ conop_implies_QCONSYM actions (case snd (pop !! 0) of { StackValue_QCONSYM value -> value; _ -> undefined })
                    193 ->
                      Monad.liftM StackValue_conop $ conop_implies_BACKQUOTE_QCONID_BACKQUOTE actions (case snd (pop !! 2) of { StackValue_BACKQUOTE value -> value; _ -> undefined }) (case snd (pop !! 1) of { StackValue_QCONID value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_BACKQUOTE value -> value; _ -> undefined })
                    194 ->
                      Monad.liftM StackValue_op $ op_implies_varop actions (case snd (pop !! 0) of { StackValue_varop value -> value; _ -> undefined })
                    195 ->
                      Monad.liftM StackValue_op $ op_implies_conop actions (case snd (pop !! 0) of { StackValue_conop value -> value; _ -> undefined })
                    196 ->
                      Monad.liftM StackValue_as_opt $ as_opt_implies actions
                    197 ->
                      Monad.liftM StackValue_as_opt $ as_opt_implies_AS_modid actions (case snd (pop !! 1) of { StackValue_AS value -> value; _ -> undefined }) (case snd (pop !! 0) of { StackValue_modid value -> value; _ -> undefined })
                    198 ->
                      Monad.liftM StackValue_qualified_opt $ qualified_opt_implies actions
                    199 ->
                      Monad.liftM StackValue_qualified_opt $ qualified_opt_implies_QUALIFIED actions (case snd (pop !! 0) of { StackValue_QUALIFIED value -> value; _ -> undefined })
                    200 ->
                      Monad.liftM StackValue_tyvar $ tyvar_implies_AS actions (case snd (pop !! 0) of { StackValue_AS value -> value; _ -> undefined })
                    201 ->
                      Monad.liftM StackValue_tyvar $ tyvar_implies_EXPORT actions (case snd (pop !! 0) of { StackValue_EXPORT value -> value; _ -> undefined })
                    202 ->
                      Monad.liftM StackValue_tyvar $ tyvar_implies_QVARID actions (case snd (pop !! 0) of { StackValue_QVARID value -> value; _ -> undefined })
                    203 ->
                      Monad.liftM StackValue_tycls $ tycls_implies_QCONID actions (case snd (pop !! 0) of { StackValue_QCONID value -> value; _ -> undefined })
                    204 ->
                      Monad.liftM StackValue_modid $ modid_implies_QCONID actions (case snd (pop !! 0) of { StackValue_QCONID value -> value; _ -> undefined })
                    205 ->
                      Monad.liftM StackValue_integer_opt $ integer_opt_implies actions
                    206 ->
                      Monad.liftM StackValue_integer_opt $ integer_opt_implies_INTEGER actions (case snd (pop !! 0) of { StackValue_INTEGER value -> value; _ -> undefined })
                    207 ->
                      Monad.liftM StackValue_semicolon_opt $ semicolon_opt_implies actions
                    208 ->
                      Monad.liftM StackValue_semicolon_opt $ semicolon_opt_implies_SEMICOLON actions (case snd (pop !! 0) of { StackValue_SEMICOLON value -> value; _ -> undefined })
                parse' ((q, value) : stack') tokens
        Just Accept ->
          case stack of { [(_, StackValue_module' value)] -> return $ Right (value, tokens); _ -> case tokens of { [] -> return $ Left $ Nothing; (token : _) -> return $ Left $ Just token }}


semanticActions :: Monad m => SemanticActions m
semanticActions = SemanticActions
  { module'_implies_MODULE_modid_exports_opt_WHERE_body = \mODULE0 modid1 exports_opt2 wHERE3 body4 ->
      return $ Module'_implies_MODULE_modid_exports_opt_WHERE_body mODULE0 modid1 exports_opt2 wHERE3 body4
  , module'_implies_body = \body0 ->
      return $ Module'_implies_body body0
  , body_implies_LBRACE_topdecls_RBRACE = \lBRACE0 topdecls1 rBRACE2 ->
      return $ Body_implies_LBRACE_topdecls_RBRACE lBRACE0 topdecls1 rBRACE2
  , exports_opt_implies =
      return $ Exports_opt_implies
  , exports_opt_implies_exports = \exports0 ->
      return $ Exports_opt_implies_exports exports0
  , exports_implies_LPAREN_export_seq_RPAREN = \lPAREN0 export_seq1 rPAREN2 ->
      return $ Exports_implies_LPAREN_export_seq_RPAREN lPAREN0 export_seq1 rPAREN2
  , export_seq_implies =
      return $ Export_seq_implies
  , export_seq_implies_export = \export0 ->
      return $ Export_seq_implies_export export0
  , export_seq_implies_export_COMMA_export_seq = \export0 cOMMA1 export_seq2 ->
      return $ Export_seq_implies_export_COMMA_export_seq export0 cOMMA1 export_seq2
  , export_implies_var = \var0 ->
      return $ Export_implies_var var0
  , export_implies_con = \con0 ->
      return $ Export_implies_con con0
  , export_implies_con_LPAREN_RPAREN = \con0 lPAREN1 rPAREN2 ->
      return $ Export_implies_con_LPAREN_RPAREN con0 lPAREN1 rPAREN2
  , export_implies_con_LPAREN_DOT_DOT_RPAREN = \con0 lPAREN1 dOT_DOT2 rPAREN3 ->
      return $ Export_implies_con_LPAREN_DOT_DOT_RPAREN con0 lPAREN1 dOT_DOT2 rPAREN3
  , export_implies_con_LPAREN_cname_seq_RPAREN = \con0 lPAREN1 cname_seq2 rPAREN3 ->
      return $ Export_implies_con_LPAREN_cname_seq_RPAREN con0 lPAREN1 cname_seq2 rPAREN3
  , export_implies_MODULE_modid = \mODULE0 modid1 ->
      return $ Export_implies_MODULE_modid mODULE0 modid1
  , import_seq_implies =
      return $ Import_seq_implies
  , import_seq_implies_import' = \import'0 ->
      return $ Import_seq_implies_import' import'0
  , import_seq_implies_import'_COMMA_import_seq = \import'0 cOMMA1 import_seq2 ->
      return $ Import_seq_implies_import'_COMMA_import_seq import'0 cOMMA1 import_seq2
  , import'_implies_var = \var0 ->
      return $ Import'_implies_var var0
  , import'_implies_con = \con0 ->
      return $ Import'_implies_con con0
  , import'_implies_con_LPAREN_RPAREN = \con0 lPAREN1 rPAREN2 ->
      return $ Import'_implies_con_LPAREN_RPAREN con0 lPAREN1 rPAREN2
  , import'_implies_con_LPAREN_DOT_DOT_RPAREN = \con0 lPAREN1 dOT_DOT2 rPAREN3 ->
      return $ Import'_implies_con_LPAREN_DOT_DOT_RPAREN con0 lPAREN1 dOT_DOT2 rPAREN3
  , import'_implies_con_LPAREN_cname_seq_RPAREN = \con0 lPAREN1 cname_seq2 rPAREN3 ->
      return $ Import'_implies_con_LPAREN_cname_seq_RPAREN con0 lPAREN1 cname_seq2 rPAREN3
  , cname_seq_implies_cname = \cname0 ->
      return $ Cname_seq_implies_cname cname0
  , cname_seq_implies_cname_COMMA_cname_seq = \cname0 cOMMA1 cname_seq2 ->
      return $ Cname_seq_implies_cname_COMMA_cname_seq cname0 cOMMA1 cname_seq2
  , cname_implies_var = \var0 ->
      return $ Cname_implies_var var0
  , cname_implies_con = \con0 ->
      return $ Cname_implies_con con0
  , topdecls_implies_topdecl = \topdecl0 ->
      return $ Topdecls_implies_topdecl topdecl0
  , topdecls_implies_topdecl_SEMICOLON_topdecls = \topdecl0 sEMICOLON1 topdecls2 ->
      return $ Topdecls_implies_topdecl_SEMICOLON_topdecls topdecl0 sEMICOLON1 topdecls2
  , topdecl_implies_IMPORT_qualified_opt_modid_as_opt = \iMPORT0 qualified_opt1 modid2 as_opt3 ->
      return $ Topdecl_implies_IMPORT_qualified_opt_modid_as_opt iMPORT0 qualified_opt1 modid2 as_opt3
  , topdecl_implies_IMPORT_qualified_opt_modid_as_opt_LPAREN_import_seq_RPAREN = \iMPORT0 qualified_opt1 modid2 as_opt3 lPAREN4 import_seq5 rPAREN6 ->
      return $ Topdecl_implies_IMPORT_qualified_opt_modid_as_opt_LPAREN_import_seq_RPAREN iMPORT0 qualified_opt1 modid2 as_opt3 lPAREN4 import_seq5 rPAREN6
  , topdecl_implies_IMPORT_qualified_opt_modid_as_opt_HIDING_LPAREN_import_seq_RPAREN = \iMPORT0 qualified_opt1 modid2 as_opt3 hIDING4 lPAREN5 import_seq6 rPAREN7 ->
      return $ Topdecl_implies_IMPORT_qualified_opt_modid_as_opt_HIDING_LPAREN_import_seq_RPAREN iMPORT0 qualified_opt1 modid2 as_opt3 hIDING4 lPAREN5 import_seq6 rPAREN7
  , topdecl_implies_TYPE_btype_EQUAL_type' = \tYPE0 btype1 eQUAL2 type'3 ->
      return $ Topdecl_implies_TYPE_btype_EQUAL_type' tYPE0 btype1 eQUAL2 type'3
  , topdecl_implies_DATA_btype_constrs_opt = \dATA0 btype1 constrs_opt2 ->
      return $ Topdecl_implies_DATA_btype_constrs_opt dATA0 btype1 constrs_opt2
  , topdecl_implies_DATA_btype_constrs_opt_DERIVING_dclass = \dATA0 btype1 constrs_opt2 dERIVING3 dclass4 ->
      return $ Topdecl_implies_DATA_btype_constrs_opt_DERIVING_dclass dATA0 btype1 constrs_opt2 dERIVING3 dclass4
  , topdecl_implies_DATA_btype_constrs_opt_DERIVING_LPAREN_RPAREN = \dATA0 btype1 constrs_opt2 dERIVING3 lPAREN4 rPAREN5 ->
      return $ Topdecl_implies_DATA_btype_constrs_opt_DERIVING_LPAREN_RPAREN dATA0 btype1 constrs_opt2 dERIVING3 lPAREN4 rPAREN5
  , topdecl_implies_DATA_btype_constrs_opt_DERIVING_LPAREN_dclass_seq_RPAREN = \dATA0 btype1 constrs_opt2 dERIVING3 lPAREN4 dclass_seq5 rPAREN6 ->
      return $ Topdecl_implies_DATA_btype_constrs_opt_DERIVING_LPAREN_dclass_seq_RPAREN dATA0 btype1 constrs_opt2 dERIVING3 lPAREN4 dclass_seq5 rPAREN6
  , topdecl_implies_DATA_btype_DARROW_btype_constrs_opt = \dATA0 btype1 dARROW2 btype3 constrs_opt4 ->
      return $ Topdecl_implies_DATA_btype_DARROW_btype_constrs_opt dATA0 btype1 dARROW2 btype3 constrs_opt4
  , topdecl_implies_DATA_btype_DARROW_btype_constrs_opt_DERIVING_dclass = \dATA0 btype1 dARROW2 btype3 constrs_opt4 dERIVING5 dclass6 ->
      return $ Topdecl_implies_DATA_btype_DARROW_btype_constrs_opt_DERIVING_dclass dATA0 btype1 dARROW2 btype3 constrs_opt4 dERIVING5 dclass6
  , topdecl_implies_DATA_btype_DARROW_btype_constrs_opt_DERIVING_LPAREN_RPAREN = \dATA0 btype1 dARROW2 btype3 constrs_opt4 dERIVING5 lPAREN6 rPAREN7 ->
      return $ Topdecl_implies_DATA_btype_DARROW_btype_constrs_opt_DERIVING_LPAREN_RPAREN dATA0 btype1 dARROW2 btype3 constrs_opt4 dERIVING5 lPAREN6 rPAREN7
  , topdecl_implies_DATA_btype_DARROW_btype_constrs_opt_DERIVING_LPAREN_dclass_seq_RPAREN = \dATA0 btype1 dARROW2 btype3 constrs_opt4 dERIVING5 lPAREN6 dclass_seq7 rPAREN8 ->
      return $ Topdecl_implies_DATA_btype_DARROW_btype_constrs_opt_DERIVING_LPAREN_dclass_seq_RPAREN dATA0 btype1 dARROW2 btype3 constrs_opt4 dERIVING5 lPAREN6 dclass_seq7 rPAREN8
  , topdecl_implies_NEWTYPE_btype_newconstr = \nEWTYPE0 btype1 newconstr2 ->
      return $ Topdecl_implies_NEWTYPE_btype_newconstr nEWTYPE0 btype1 newconstr2
  , topdecl_implies_NEWTYPE_btype_newconstr_DERIVING_dclass = \nEWTYPE0 btype1 newconstr2 dERIVING3 dclass4 ->
      return $ Topdecl_implies_NEWTYPE_btype_newconstr_DERIVING_dclass nEWTYPE0 btype1 newconstr2 dERIVING3 dclass4
  , topdecl_implies_NEWTYPE_btype_newconstr_DERIVING_LPAREN_RPAREN = \nEWTYPE0 btype1 newconstr2 dERIVING3 lPAREN4 rPAREN5 ->
      return $ Topdecl_implies_NEWTYPE_btype_newconstr_DERIVING_LPAREN_RPAREN nEWTYPE0 btype1 newconstr2 dERIVING3 lPAREN4 rPAREN5
  , topdecl_implies_NEWTYPE_btype_newconstr_DERIVING_LPAREN_dclass_seq_RPAREN = \nEWTYPE0 btype1 newconstr2 dERIVING3 lPAREN4 dclass_seq5 rPAREN6 ->
      return $ Topdecl_implies_NEWTYPE_btype_newconstr_DERIVING_LPAREN_dclass_seq_RPAREN nEWTYPE0 btype1 newconstr2 dERIVING3 lPAREN4 dclass_seq5 rPAREN6
  , topdecl_implies_NEWTYPE_btype_DARROW_btype_newconstr = \nEWTYPE0 btype1 dARROW2 btype3 newconstr4 ->
      return $ Topdecl_implies_NEWTYPE_btype_DARROW_btype_newconstr nEWTYPE0 btype1 dARROW2 btype3 newconstr4
  , topdecl_implies_NEWTYPE_btype_DARROW_btype_newconstr_DERIVING_dclass = \nEWTYPE0 btype1 dARROW2 btype3 newconstr4 dERIVING5 dclass6 ->
      return $ Topdecl_implies_NEWTYPE_btype_DARROW_btype_newconstr_DERIVING_dclass nEWTYPE0 btype1 dARROW2 btype3 newconstr4 dERIVING5 dclass6
  , topdecl_implies_NEWTYPE_btype_DARROW_btype_newconstr_DERIVING_LPAREN_RPAREN = \nEWTYPE0 btype1 dARROW2 btype3 newconstr4 dERIVING5 lPAREN6 rPAREN7 ->
      return $ Topdecl_implies_NEWTYPE_btype_DARROW_btype_newconstr_DERIVING_LPAREN_RPAREN nEWTYPE0 btype1 dARROW2 btype3 newconstr4 dERIVING5 lPAREN6 rPAREN7
  , topdecl_implies_NEWTYPE_btype_DARROW_btype_newconstr_DERIVING_LPAREN_dclass_seq_RPAREN = \nEWTYPE0 btype1 dARROW2 btype3 newconstr4 dERIVING5 lPAREN6 dclass_seq7 rPAREN8 ->
      return $ Topdecl_implies_NEWTYPE_btype_DARROW_btype_newconstr_DERIVING_LPAREN_dclass_seq_RPAREN nEWTYPE0 btype1 dARROW2 btype3 newconstr4 dERIVING5 lPAREN6 dclass_seq7 rPAREN8
  , topdecl_implies_CLASS_btype_cdecls_opt = \cLASS0 btype1 cdecls_opt2 ->
      return $ Topdecl_implies_CLASS_btype_cdecls_opt cLASS0 btype1 cdecls_opt2
  , topdecl_implies_CLASS_btype_DARROW_btype_cdecls_opt = \cLASS0 btype1 dARROW2 btype3 cdecls_opt4 ->
      return $ Topdecl_implies_CLASS_btype_DARROW_btype_cdecls_opt cLASS0 btype1 dARROW2 btype3 cdecls_opt4
  , topdecl_implies_INSTANCE_btype_idecls_opt = \iNSTANCE0 btype1 idecls_opt2 ->
      return $ Topdecl_implies_INSTANCE_btype_idecls_opt iNSTANCE0 btype1 idecls_opt2
  , topdecl_implies_INSTANCE_btype_DARROW_btype_idecls_opt = \iNSTANCE0 btype1 dARROW2 btype3 idecls_opt4 ->
      return $ Topdecl_implies_INSTANCE_btype_DARROW_btype_idecls_opt iNSTANCE0 btype1 dARROW2 btype3 idecls_opt4
  , topdecl_implies_DEFAULT_LPAREN_RPAREN = \dEFAULT0 lPAREN1 rPAREN2 ->
      return $ Topdecl_implies_DEFAULT_LPAREN_RPAREN dEFAULT0 lPAREN1 rPAREN2
  , topdecl_implies_DEFAULT_LPAREN_type_seq_RPAREN = \dEFAULT0 lPAREN1 type_seq2 rPAREN3 ->
      return $ Topdecl_implies_DEFAULT_LPAREN_type_seq_RPAREN dEFAULT0 lPAREN1 type_seq2 rPAREN3
  , topdecl_implies_FOREIGN_fdecl = \fOREIGN0 fdecl1 ->
      return $ Topdecl_implies_FOREIGN_fdecl fOREIGN0 fdecl1
  , topdecl_implies_decl = \decl0 ->
      return $ Topdecl_implies_decl decl0
  , decls_implies_LBRACE_decl_seq_RBRACE = \lBRACE0 decl_seq1 rBRACE2 ->
      return $ Decls_implies_LBRACE_decl_seq_RBRACE lBRACE0 decl_seq1 rBRACE2
  , decl_seq_implies_decl = \decl0 ->
      return $ Decl_seq_implies_decl decl0
  , decl_seq_implies_decl_SEMICOLON_decl_seq = \decl0 sEMICOLON1 decl_seq2 ->
      return $ Decl_seq_implies_decl_SEMICOLON_decl_seq decl0 sEMICOLON1 decl_seq2
  , decl_implies_gendecl = \gendecl0 ->
      return $ Decl_implies_gendecl gendecl0
  , decl_implies_pat_EQUAL_exp = \pat0 eQUAL1 exp2 ->
      return $ Decl_implies_pat_EQUAL_exp pat0 eQUAL1 exp2
  , decl_implies_pat_EQUAL_exp_WHERE_decls = \pat0 eQUAL1 exp2 wHERE3 decls4 ->
      return $ Decl_implies_pat_EQUAL_exp_WHERE_decls pat0 eQUAL1 exp2 wHERE3 decls4
  , decl_implies_pat_PIPE_gdrhs = \pat0 pIPE1 gdrhs2 ->
      return $ Decl_implies_pat_PIPE_gdrhs pat0 pIPE1 gdrhs2
  , decl_implies_pat_PIPE_gdrhs_WHERE_decls = \pat0 pIPE1 gdrhs2 wHERE3 decls4 ->
      return $ Decl_implies_pat_PIPE_gdrhs_WHERE_decls pat0 pIPE1 gdrhs2 wHERE3 decls4
  , cdecls_opt_implies =
      return $ Cdecls_opt_implies
  , cdecls_opt_implies_WHERE_cdecls = \wHERE0 cdecls1 ->
      return $ Cdecls_opt_implies_WHERE_cdecls wHERE0 cdecls1
  , cdecls_implies_LBRACE_cdecl_seq_RBRACE = \lBRACE0 cdecl_seq1 rBRACE2 ->
      return $ Cdecls_implies_LBRACE_cdecl_seq_RBRACE lBRACE0 cdecl_seq1 rBRACE2
  , cdecl_seq_implies_cdecl = \cdecl0 ->
      return $ Cdecl_seq_implies_cdecl cdecl0
  , cdecl_seq_implies_cdecl_SEMICOLON_cdecl_seq = \cdecl0 sEMICOLON1 cdecl_seq2 ->
      return $ Cdecl_seq_implies_cdecl_SEMICOLON_cdecl_seq cdecl0 sEMICOLON1 cdecl_seq2
  , cdecl_implies_gendecl = \gendecl0 ->
      return $ Cdecl_implies_gendecl gendecl0
  , cdecl_implies_pat_EQUAL_exp = \pat0 eQUAL1 exp2 ->
      return $ Cdecl_implies_pat_EQUAL_exp pat0 eQUAL1 exp2
  , cdecl_implies_pat_EQUAL_exp_WHERE_decls = \pat0 eQUAL1 exp2 wHERE3 decls4 ->
      return $ Cdecl_implies_pat_EQUAL_exp_WHERE_decls pat0 eQUAL1 exp2 wHERE3 decls4
  , cdecl_implies_pat_PIPE_gdrhs = \pat0 pIPE1 gdrhs2 ->
      return $ Cdecl_implies_pat_PIPE_gdrhs pat0 pIPE1 gdrhs2
  , cdecl_implies_pat_PIPE_gdrhs_WHERE_decls = \pat0 pIPE1 gdrhs2 wHERE3 decls4 ->
      return $ Cdecl_implies_pat_PIPE_gdrhs_WHERE_decls pat0 pIPE1 gdrhs2 wHERE3 decls4
  , idecls_opt_implies =
      return $ Idecls_opt_implies
  , idecls_opt_implies_WHERE_idecls = \wHERE0 idecls1 ->
      return $ Idecls_opt_implies_WHERE_idecls wHERE0 idecls1
  , idecls_implies_LBRACE_idecl_seq_RBRACE = \lBRACE0 idecl_seq1 rBRACE2 ->
      return $ Idecls_implies_LBRACE_idecl_seq_RBRACE lBRACE0 idecl_seq1 rBRACE2
  , idecl_seq_implies_idecl = \idecl0 ->
      return $ Idecl_seq_implies_idecl idecl0
  , idecl_seq_implies_idecl_SEMICOLON_idecl_seq = \idecl0 sEMICOLON1 idecl_seq2 ->
      return $ Idecl_seq_implies_idecl_SEMICOLON_idecl_seq idecl0 sEMICOLON1 idecl_seq2
  , idecl_implies =
      return $ Idecl_implies
  , idecl_implies_pat_EQUAL_exp = \pat0 eQUAL1 exp2 ->
      return $ Idecl_implies_pat_EQUAL_exp pat0 eQUAL1 exp2
  , idecl_implies_pat_EQUAL_exp_WHERE_decls = \pat0 eQUAL1 exp2 wHERE3 decls4 ->
      return $ Idecl_implies_pat_EQUAL_exp_WHERE_decls pat0 eQUAL1 exp2 wHERE3 decls4
  , idecl_implies_pat_PIPE_gdrhs = \pat0 pIPE1 gdrhs2 ->
      return $ Idecl_implies_pat_PIPE_gdrhs pat0 pIPE1 gdrhs2
  , idecl_implies_pat_PIPE_gdrhs_WHERE_decls = \pat0 pIPE1 gdrhs2 wHERE3 decls4 ->
      return $ Idecl_implies_pat_PIPE_gdrhs_WHERE_decls pat0 pIPE1 gdrhs2 wHERE3 decls4
  , gendecl_implies =
      return $ Gendecl_implies
  , gendecl_implies_vars_COLON_COLON_type' = \vars0 cOLON_COLON1 type'2 ->
      return $ Gendecl_implies_vars_COLON_COLON_type' vars0 cOLON_COLON1 type'2
  , gendecl_implies_vars_COLON_COLON_btype_DARROW_type' = \vars0 cOLON_COLON1 btype2 dARROW3 type'4 ->
      return $ Gendecl_implies_vars_COLON_COLON_btype_DARROW_type' vars0 cOLON_COLON1 btype2 dARROW3 type'4
  , gendecl_implies_fixity_integer_opt_ops = \fixity0 integer_opt1 ops2 ->
      return $ Gendecl_implies_fixity_integer_opt_ops fixity0 integer_opt1 ops2
  , ops_implies_MINUS = \mINUS0 ->
      return $ Ops_implies_MINUS mINUS0
  , ops_implies_op = \op0 ->
      return $ Ops_implies_op op0
  , ops_implies_MINUS_COMMA_ops = \mINUS0 cOMMA1 ops2 ->
      return $ Ops_implies_MINUS_COMMA_ops mINUS0 cOMMA1 ops2
  , ops_implies_op_COMMA_ops = \op0 cOMMA1 ops2 ->
      return $ Ops_implies_op_COMMA_ops op0 cOMMA1 ops2
  , vars_implies_var = \var0 ->
      return $ Vars_implies_var var0
  , vars_implies_var_COMMA_vars = \var0 cOMMA1 vars2 ->
      return $ Vars_implies_var_COMMA_vars var0 cOMMA1 vars2
  , fixity_implies_INFIXL = \iNFIXL0 ->
      return $ Fixity_implies_INFIXL iNFIXL0
  , fixity_implies_INFIXR = \iNFIXR0 ->
      return $ Fixity_implies_INFIXR iNFIXR0
  , fixity_implies_INFIX = \iNFIX0 ->
      return $ Fixity_implies_INFIX iNFIX0
  , type_seq_implies_type' = \type'0 ->
      return $ Type_seq_implies_type' type'0
  , type_seq_implies_type'_COMMA_type_seq = \type'0 cOMMA1 type_seq2 ->
      return $ Type_seq_implies_type'_COMMA_type_seq type'0 cOMMA1 type_seq2
  , type'_implies_btype = \btype0 ->
      return $ Type'_implies_btype btype0
  , type'_implies_btype_RARROW_type' = \btype0 rARROW1 type'2 ->
      return $ Type'_implies_btype_RARROW_type' btype0 rARROW1 type'2
  , btype_implies_atype = \atype0 ->
      return $ Btype_implies_atype atype0
  , btype_implies_btype_atype = \btype0 atype1 ->
      return $ Btype_implies_btype_atype btype0 atype1
  , atype_implies_gtycon = \gtycon0 ->
      return $ Atype_implies_gtycon gtycon0
  , atype_implies_tyvar = \tyvar0 ->
      return $ Atype_implies_tyvar tyvar0
  , atype_implies_LPAREN_type_seq2_RPAREN = \lPAREN0 type_seq21 rPAREN2 ->
      return $ Atype_implies_LPAREN_type_seq2_RPAREN lPAREN0 type_seq21 rPAREN2
  , atype_implies_LBRACKET_type'_RBRACKET = \lBRACKET0 type'1 rBRACKET2 ->
      return $ Atype_implies_LBRACKET_type'_RBRACKET lBRACKET0 type'1 rBRACKET2
  , atype_implies_LPAREN_type'_RPAREN = \lPAREN0 type'1 rPAREN2 ->
      return $ Atype_implies_LPAREN_type'_RPAREN lPAREN0 type'1 rPAREN2
  , atype_implies_EXCL_atype = \eXCL0 atype1 ->
      return $ Atype_implies_EXCL_atype eXCL0 atype1
  , type_seq2_implies_type'_COMMA_type' = \type'0 cOMMA1 type'2 ->
      return $ Type_seq2_implies_type'_COMMA_type' type'0 cOMMA1 type'2
  , type_seq2_implies_type'_COMMA_type_seq2 = \type'0 cOMMA1 type_seq22 ->
      return $ Type_seq2_implies_type'_COMMA_type_seq2 type'0 cOMMA1 type_seq22
  , gtycon_implies_con = \con0 ->
      return $ Gtycon_implies_con con0
  , gtycon_implies_LPAREN_RPAREN = \lPAREN0 rPAREN1 ->
      return $ Gtycon_implies_LPAREN_RPAREN lPAREN0 rPAREN1
  , gtycon_implies_LBRACKET_RBRACKET = \lBRACKET0 rBRACKET1 ->
      return $ Gtycon_implies_LBRACKET_RBRACKET lBRACKET0 rBRACKET1
  , gtycon_implies_LPAREN_RARROW_RPAREN = \lPAREN0 rARROW1 rPAREN2 ->
      return $ Gtycon_implies_LPAREN_RARROW_RPAREN lPAREN0 rARROW1 rPAREN2
  , gtycon_implies_LPAREN_comma_list_RPAREN = \lPAREN0 comma_list1 rPAREN2 ->
      return $ Gtycon_implies_LPAREN_comma_list_RPAREN lPAREN0 comma_list1 rPAREN2
  , comma_list_implies_COMMA = \cOMMA0 ->
      return $ Comma_list_implies_COMMA cOMMA0
  , comma_list_implies_COMMA_comma_list = \cOMMA0 comma_list1 ->
      return $ Comma_list_implies_COMMA_comma_list cOMMA0 comma_list1
  , constrs_opt_implies =
      return $ Constrs_opt_implies
  , constrs_opt_implies_EQUAL_constrs = \eQUAL0 constrs1 ->
      return $ Constrs_opt_implies_EQUAL_constrs eQUAL0 constrs1
  , constrs_implies_constr = \constr0 ->
      return $ Constrs_implies_constr constr0
  , constrs_implies_constr_PIPE_constrs = \constr0 pIPE1 constrs2 ->
      return $ Constrs_implies_constr_PIPE_constrs constr0 pIPE1 constrs2
  , constr_implies_btype = \btype0 ->
      return $ Constr_implies_btype btype0
  , constr_implies_btype_conop_btype = \btype0 conop1 btype2 ->
      return $ Constr_implies_btype_conop_btype btype0 conop1 btype2
  , constr_implies_con_LBRACE_RBRACE = \con0 lBRACE1 rBRACE2 ->
      return $ Constr_implies_con_LBRACE_RBRACE con0 lBRACE1 rBRACE2
  , constr_implies_con_LBRACE_fielddecl_seq_RBRACE = \con0 lBRACE1 fielddecl_seq2 rBRACE3 ->
      return $ Constr_implies_con_LBRACE_fielddecl_seq_RBRACE con0 lBRACE1 fielddecl_seq2 rBRACE3
  , newconstr_implies_EQUAL_con_atype = \eQUAL0 con1 atype2 ->
      return $ Newconstr_implies_EQUAL_con_atype eQUAL0 con1 atype2
  , newconstr_implies_EQUAL_con_LBRACE_var_COLON_COLON_type'_RBRACE = \eQUAL0 con1 lBRACE2 var3 cOLON_COLON4 type'5 rBRACE6 ->
      return $ Newconstr_implies_EQUAL_con_LBRACE_var_COLON_COLON_type'_RBRACE eQUAL0 con1 lBRACE2 var3 cOLON_COLON4 type'5 rBRACE6
  , fielddecl_seq_implies_fielddecl = \fielddecl0 ->
      return $ Fielddecl_seq_implies_fielddecl fielddecl0
  , fielddecl_seq_implies_fielddecl_COMMA_fielddecl_seq = \fielddecl0 cOMMA1 fielddecl_seq2 ->
      return $ Fielddecl_seq_implies_fielddecl_COMMA_fielddecl_seq fielddecl0 cOMMA1 fielddecl_seq2
  , fielddecl_implies_vars_COLON_COLON_type' = \vars0 cOLON_COLON1 type'2 ->
      return $ Fielddecl_implies_vars_COLON_COLON_type' vars0 cOLON_COLON1 type'2
  , dclass_seq_implies_dclass = \dclass0 ->
      return $ Dclass_seq_implies_dclass dclass0
  , dclass_seq_implies_dclass_COMMA_dclass_seq = \dclass0 cOMMA1 dclass_seq2 ->
      return $ Dclass_seq_implies_dclass_COMMA_dclass_seq dclass0 cOMMA1 dclass_seq2
  , dclass_implies_QCONID = \qCONID0 ->
      return $ Dclass_implies_QCONID qCONID0
  , fdecl_implies_IMPORT_callconv_impent_var_COLON_COLON_type' = \iMPORT0 callconv1 impent2 var3 cOLON_COLON4 type'5 ->
      return $ Fdecl_implies_IMPORT_callconv_impent_var_COLON_COLON_type' iMPORT0 callconv1 impent2 var3 cOLON_COLON4 type'5
  , fdecl_implies_IMPORT_callconv_safety_impent_var_COLON_COLON_type' = \iMPORT0 callconv1 safety2 impent3 var4 cOLON_COLON5 type'6 ->
      return $ Fdecl_implies_IMPORT_callconv_safety_impent_var_COLON_COLON_type' iMPORT0 callconv1 safety2 impent3 var4 cOLON_COLON5 type'6
  , fdecl_implies_EXPORT_callconv_expent_var_COLON_COLON_type' = \eXPORT0 callconv1 expent2 var3 cOLON_COLON4 type'5 ->
      return $ Fdecl_implies_EXPORT_callconv_expent_var_COLON_COLON_type' eXPORT0 callconv1 expent2 var3 cOLON_COLON4 type'5
  , callconv_implies_AS = \aS0 ->
      return $ Callconv_implies_AS aS0
  , callconv_implies_EXPORT = \eXPORT0 ->
      return $ Callconv_implies_EXPORT eXPORT0
  , callconv_implies_QVARID = \qVARID0 ->
      return $ Callconv_implies_QVARID qVARID0
  , impent_implies_STRING = \sTRING0 ->
      return $ Impent_implies_STRING sTRING0
  , expent_implies_STRING = \sTRING0 ->
      return $ Expent_implies_STRING sTRING0
  , safety_implies_AS = \aS0 ->
      return $ Safety_implies_AS aS0
  , safety_implies_EXPORT = \eXPORT0 ->
      return $ Safety_implies_EXPORT eXPORT0
  , safety_implies_QVARID = \qVARID0 ->
      return $ Safety_implies_QVARID qVARID0
  , gdrhs_implies_guards_EQUAL_exp = \guards0 eQUAL1 exp2 ->
      return $ Gdrhs_implies_guards_EQUAL_exp guards0 eQUAL1 exp2
  , gdrhs_implies_guards_EQUAL_exp_PIPE_gdrhs = \guards0 eQUAL1 exp2 pIPE3 gdrhs4 ->
      return $ Gdrhs_implies_guards_EQUAL_exp_PIPE_gdrhs guards0 eQUAL1 exp2 pIPE3 gdrhs4
  , guards_implies_guard = \guard0 ->
      return $ Guards_implies_guard guard0
  , guards_implies_guard_COMMA_guards = \guard0 cOMMA1 guards2 ->
      return $ Guards_implies_guard_COMMA_guards guard0 cOMMA1 guards2
  , guard_implies_infixexp_LARROW_exp = \infixexp0 lARROW1 exp2 ->
      return $ Guard_implies_infixexp_LARROW_exp infixexp0 lARROW1 exp2
  , guard_implies_LET_decls = \lET0 decls1 ->
      return $ Guard_implies_LET_decls lET0 decls1
  , guard_implies_infixexp = \infixexp0 ->
      return $ Guard_implies_infixexp infixexp0
  , exp_implies_infixexp = \infixexp0 ->
      return $ Exp_implies_infixexp infixexp0
  , infixexp_implies_LAMBDA_pat_RARROW_exp = \lAMBDA0 pat1 rARROW2 exp3 ->
      return $ Infixexp_implies_LAMBDA_pat_RARROW_exp lAMBDA0 pat1 rARROW2 exp3
  , infixexp_implies_LET_decls_IN_exp = \lET0 decls1 iN2 exp3 ->
      return $ Infixexp_implies_LET_decls_IN_exp lET0 decls1 iN2 exp3
  , infixexp_implies_IF_exp_semicolon_opt_THEN_exp_semicolon_opt_ELSE_exp = \iF0 exp1 semicolon_opt2 tHEN3 exp4 semicolon_opt5 eLSE6 exp7 ->
      return $ Infixexp_implies_IF_exp_semicolon_opt_THEN_exp_semicolon_opt_ELSE_exp iF0 exp1 semicolon_opt2 tHEN3 exp4 semicolon_opt5 eLSE6 exp7
  , infixexp_implies_lexp_MINUS_exp = \lexp0 mINUS1 exp2 ->
      return $ Infixexp_implies_lexp_MINUS_exp lexp0 mINUS1 exp2
  , infixexp_implies_lexp_QVARSYM_exp = \lexp0 qVARSYM1 exp2 ->
      return $ Infixexp_implies_lexp_QVARSYM_exp lexp0 qVARSYM1 exp2
  , infixexp_implies_lexp_BACKQUOTE_AS_BACKQUOTE_exp = \lexp0 bACKQUOTE1 aS2 bACKQUOTE3 exp4 ->
      return $ Infixexp_implies_lexp_BACKQUOTE_AS_BACKQUOTE_exp lexp0 bACKQUOTE1 aS2 bACKQUOTE3 exp4
  , infixexp_implies_lexp_BACKQUOTE_EXPORT_BACKQUOTE_exp = \lexp0 bACKQUOTE1 eXPORT2 bACKQUOTE3 exp4 ->
      return $ Infixexp_implies_lexp_BACKQUOTE_EXPORT_BACKQUOTE_exp lexp0 bACKQUOTE1 eXPORT2 bACKQUOTE3 exp4
  , infixexp_implies_lexp_BACKQUOTE_QVARID_BACKQUOTE_exp = \lexp0 bACKQUOTE1 qVARID2 bACKQUOTE3 exp4 ->
      return $ Infixexp_implies_lexp_BACKQUOTE_QVARID_BACKQUOTE_exp lexp0 bACKQUOTE1 qVARID2 bACKQUOTE3 exp4
  , infixexp_implies_lexp_QCONSYM_exp = \lexp0 qCONSYM1 exp2 ->
      return $ Infixexp_implies_lexp_QCONSYM_exp lexp0 qCONSYM1 exp2
  , infixexp_implies_lexp_BACKQUOTE_QCONID_BACKQUOTE_exp = \lexp0 bACKQUOTE1 qCONID2 bACKQUOTE3 exp4 ->
      return $ Infixexp_implies_lexp_BACKQUOTE_QCONID_BACKQUOTE_exp lexp0 bACKQUOTE1 qCONID2 bACKQUOTE3 exp4
  , infixexp_implies_lexp_COLON_COLON_type' = \lexp0 cOLON_COLON1 type'2 ->
      return $ Infixexp_implies_lexp_COLON_COLON_type' lexp0 cOLON_COLON1 type'2
  , infixexp_implies_lexp_COLON_COLON_btype_DARROW_type' = \lexp0 cOLON_COLON1 btype2 dARROW3 type'4 ->
      return $ Infixexp_implies_lexp_COLON_COLON_btype_DARROW_type' lexp0 cOLON_COLON1 btype2 dARROW3 type'4
  , infixexp_implies_lexp = \lexp0 ->
      return $ Infixexp_implies_lexp lexp0
  , lexp_implies_MINUS_fexp = \mINUS0 fexp1 ->
      return $ Lexp_implies_MINUS_fexp mINUS0 fexp1
  , lexp_implies_fexp = \fexp0 ->
      return $ Lexp_implies_fexp fexp0
  , fexp_implies_aexp = \aexp0 ->
      return $ Fexp_implies_aexp aexp0
  , fexp_implies_fexp_aexp = \fexp0 aexp1 ->
      return $ Fexp_implies_fexp_aexp fexp0 aexp1
  , aexp_implies_var = \var0 ->
      return $ Aexp_implies_var var0
  , aexp_implies_INTEGER = \iNTEGER0 ->
      return $ Aexp_implies_INTEGER iNTEGER0
  , aexp_implies_STRING = \sTRING0 ->
      return $ Aexp_implies_STRING sTRING0
  , aexp_implies_LPAREN_exp_RPAREN = \lPAREN0 exp1 rPAREN2 ->
      return $ Aexp_implies_LPAREN_exp_RPAREN lPAREN0 exp1 rPAREN2
  , pat_implies_apat = \apat0 ->
      return $ Pat_implies_apat apat0
  , pat_implies_pat_apat = \pat0 apat1 ->
      return $ Pat_implies_pat_apat pat0 apat1
  , pat_implies_pat_MINUS_apat = \pat0 mINUS1 apat2 ->
      return $ Pat_implies_pat_MINUS_apat pat0 mINUS1 apat2
  , pat_implies_pat_op_apat = \pat0 op1 apat2 ->
      return $ Pat_implies_pat_op_apat pat0 op1 apat2
  , apat_implies_var = \var0 ->
      return $ Apat_implies_var var0
  , apat_implies_LPAREN_pat_RPAREN = \lPAREN0 pat1 rPAREN2 ->
      return $ Apat_implies_LPAREN_pat_RPAREN lPAREN0 pat1 rPAREN2
  , var_implies_AS = \aS0 ->
      return $ Var_implies_AS aS0
  , var_implies_EXPORT = \eXPORT0 ->
      return $ Var_implies_EXPORT eXPORT0
  , var_implies_QVARID = \qVARID0 ->
      return $ Var_implies_QVARID qVARID0
  , var_implies_LPAREN_MINUS_RPAREN = \lPAREN0 mINUS1 rPAREN2 ->
      return $ Var_implies_LPAREN_MINUS_RPAREN lPAREN0 mINUS1 rPAREN2
  , var_implies_LPAREN_QVARSYM_RPAREN = \lPAREN0 qVARSYM1 rPAREN2 ->
      return $ Var_implies_LPAREN_QVARSYM_RPAREN lPAREN0 qVARSYM1 rPAREN2
  , con_implies_QCONID = \qCONID0 ->
      return $ Con_implies_QCONID qCONID0
  , con_implies_LPAREN_QCONSYM_RPAREN = \lPAREN0 qCONSYM1 rPAREN2 ->
      return $ Con_implies_LPAREN_QCONSYM_RPAREN lPAREN0 qCONSYM1 rPAREN2
  , varop_implies_QVARSYM = \qVARSYM0 ->
      return $ Varop_implies_QVARSYM qVARSYM0
  , varop_implies_BACKQUOTE_AS_BACKQUOTE = \bACKQUOTE0 aS1 bACKQUOTE2 ->
      return $ Varop_implies_BACKQUOTE_AS_BACKQUOTE bACKQUOTE0 aS1 bACKQUOTE2
  , varop_implies_BACKQUOTE_EXPORT_BACKQUOTE = \bACKQUOTE0 eXPORT1 bACKQUOTE2 ->
      return $ Varop_implies_BACKQUOTE_EXPORT_BACKQUOTE bACKQUOTE0 eXPORT1 bACKQUOTE2
  , varop_implies_BACKQUOTE_QVARID_BACKQUOTE = \bACKQUOTE0 qVARID1 bACKQUOTE2 ->
      return $ Varop_implies_BACKQUOTE_QVARID_BACKQUOTE bACKQUOTE0 qVARID1 bACKQUOTE2
  , conop_implies_QCONSYM = \qCONSYM0 ->
      return $ Conop_implies_QCONSYM qCONSYM0
  , conop_implies_BACKQUOTE_QCONID_BACKQUOTE = \bACKQUOTE0 qCONID1 bACKQUOTE2 ->
      return $ Conop_implies_BACKQUOTE_QCONID_BACKQUOTE bACKQUOTE0 qCONID1 bACKQUOTE2
  , op_implies_varop = \varop0 ->
      return $ Op_implies_varop varop0
  , op_implies_conop = \conop0 ->
      return $ Op_implies_conop conop0
  , as_opt_implies =
      return $ As_opt_implies
  , as_opt_implies_AS_modid = \aS0 modid1 ->
      return $ As_opt_implies_AS_modid aS0 modid1
  , qualified_opt_implies =
      return $ Qualified_opt_implies
  , qualified_opt_implies_QUALIFIED = \qUALIFIED0 ->
      return $ Qualified_opt_implies_QUALIFIED qUALIFIED0
  , tyvar_implies_AS = \aS0 ->
      return $ Tyvar_implies_AS aS0
  , tyvar_implies_EXPORT = \eXPORT0 ->
      return $ Tyvar_implies_EXPORT eXPORT0
  , tyvar_implies_QVARID = \qVARID0 ->
      return $ Tyvar_implies_QVARID qVARID0
  , tycls_implies_QCONID = \qCONID0 ->
      return $ Tycls_implies_QCONID qCONID0
  , modid_implies_QCONID = \qCONID0 ->
      return $ Modid_implies_QCONID qCONID0
  , integer_opt_implies =
      return $ Integer_opt_implies
  , integer_opt_implies_INTEGER = \iNTEGER0 ->
      return $ Integer_opt_implies_INTEGER iNTEGER0
  , semicolon_opt_implies =
      return $ Semicolon_opt_implies
  , semicolon_opt_implies_SEMICOLON = \sEMICOLON0 ->
      return $ Semicolon_opt_implies_SEMICOLON sEMICOLON0 }

