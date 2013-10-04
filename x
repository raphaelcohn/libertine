LFS_X="hello"

declare -a something=()
declare -A somethingelse=()

function hello_world()
{
	local -r xxx="ff"
	echo "$LFS_X"
	
	# both of the following include local variable names
	set
	
	compgen -v
}

function ourGlobalVariableNames()
{
	# compgen will include local variables, so we use a subshell...
	echo "#!/bin/bash -"
	echo "set +o allexport -o braceexpand +o emacs -o errexit +o errtrace +o functrace +o hashall +o histexpand +o history +o ignoreeof -o interactive-comments +o keyword +o monitor +o noclobber +o noexec +o noglob +o nolog +o notify +o nounset +o onecmd +o physical +o pipefail +o posix +o verbose +o vi +o xtrace;unset BASH_ENV;unset BASH_XTRACEFD;unset CDPATH;unset ENV;unset FCEDIT;unset FIGNORE;unset FUNCNEST;unset GLOBIGNORE;unset HISTCONTROL;unset HISTFILE;unset HISTFILESIZE;unset HISTIGNORE;unset HISTSIZE;unset HISTTIMEFORMAT;unset HOSTFILE;unset IGNOREEOF;unset INPUTRC;unset MAIL;unset MAILCHECK;unset MAILPATH;unset TMOUT;umask 022"
	
	compgen -v | while IFS='' read -r -d $'\n' variableName
	do
		if [ -z "$found" ]; then
			if [ "$variableName" = "_" ]; then
				found="yes"
			fi
			continue
		fi
		
		declare -p "$variableName"
	done
	
	declare -f
}

something[0]="dadad"
somethingelse['key']="qwqwqwq"

ourGlobalVariableNames
