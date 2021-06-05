# Defined in ./fish_funcs_add.fish @ line 3
function c
    if count $argv > /dev/null
	    gcc $argv -o main
    else
        echo "c - compile c files"
        echo "usage: c <c source>"
    end
end
