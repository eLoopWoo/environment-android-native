define xhelp
printf "---------------\n"
printf "\txif - info func Java*\n"
printf "---------------\n"
printf "\txis - info shared\n"
printf "---------------\n"
printf "\txt - target remote $ GDBIP:$ GDBPORT\n"
printf "---------------\n"
printf "\txi - x/10i $pc - 10\n"
printf "---------------\n"
printf "\txx - show current state\n"
printf "---------------\n"
printf "\txsi - single step and show current state\n"
printf "---------------\n"
printf "\txni - next step and show current state\n"
printf "---------------\n"
end

define xif
info func Java*
end

define xis
info shared
end

define xt
target remote :9998
end

define xi
x/10i $pc - 10
end

define xx
printf "---------------\n"
x/10gx $sp
printf "---------------\n"
info reg
printf "---------------\n"
x/20i $pc - 0x10
printf "---------------\n"
info frame
printf "---------------\n"
end

define xni
ni
printf "---------------\n"
x/10gx $sp
printf "---------------\n"
info reg
printf "---------------\n"
x/20i $pc - 0x10
printf "---------------\n"
info frame
printf "---------------\n"
end

define xsi
si
printf "---------------\n"
x/10gx $sp
printf "---------------\n"
info reg
printf "---------------\n"
x/20i $pc - 0x10
printf "---------------\n"
info frame
printf "---------------\n"
end

define set_libs
	set sysroot libs/
	set solib-search-path libs/
	file libs/app_process32
end

