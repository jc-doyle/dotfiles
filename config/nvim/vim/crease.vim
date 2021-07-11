        " %     A literal "%".
        " =     Seperation point between alignment sections. Each section will be
        "       seperated by an equal number of spaces.
        " t     The text in the first line of the fold, stripped of comments and
        "       fold markers.
        " l     The number of lines in the fold.
        " f     The fold character defined in |fillchars| ("-" by default).
        " {     Evaluate the expression between "%{" and "}" and substitute
        "       the result.

set fillchars=fold:\    " space
let g:crease_foldtext = { 'default': '%t ⟩ %= ⟨ %l lines' }
