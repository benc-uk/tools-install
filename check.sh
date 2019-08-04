base=$HOME/dev
for dir in $base/*/     # list directories in the form "/tmp/dirname/"
do
    dir=${dir%*/}      # remove the trailing "/"
    #echo ${dir##*/}    # print everything after the final "/"
    echo $dir
    cd $dir
    git status -s
    echo -e "==========\n"
done