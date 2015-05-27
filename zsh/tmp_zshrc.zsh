# ssh aliases
#------------------------------------------------------------------------------
alias ssh164='ssh -X cs164-em@hive8.cs.berkeley.edu'
alias ssh61b='ssh -X cs61b@cs61b.eecs.berkeley.edu'

# 61B
#------------------------------------------------------------------------------
export CS61B_LIB_DIR="/Users/Aleks/Documents/School/61B/course-materials/lib"
export JAVA_TOOLS_DIR="/Library/Java/JavaVirtualMachines/jdk1.7.0_17.jdk/Contents/Home/lib"
export CLASSPATH="$CLASSPATH:$CS61B_LIB_DIR/*:$JAVA_TOOLS_DIR/*:./*"

export CS61B_PYLIB_DIR="/Users/Aleks/Documents/School/61B/course-materials/lib/pygrader"
export PYTHONPATH="$PYTHONPATH:$CS61B_PYLIB_DIR"

export PATH=$PATH:/Users/Aleks/Documents/School/61b/course-materials/lib/pygrader

# revolv
#------------------------------------------------------------------------------
source "$HOME/Documents/School/revolv/.revolv_bash_profile"

# CS164
#------------------------------------------------------------------------------
export PATH=$PATH:/Users/Aleks/Documents/School/164/lib
export PATH=$PATH:/Users/Aleks/local/bin
export PATH=$PATH:/Users/Aleks/Dropbox/School/164/cs164-software/pyunparse

alias py5="/Users/Aleks/.pyenv/versions/2.5/bin/python2.5"
