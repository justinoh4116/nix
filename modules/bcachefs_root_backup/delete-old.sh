while getopts d:k:n: flag
do
    case "${flag}" in
        d) dir=${OPTARG};;
        n) name=${OPTARG};;
	k) keep=${OPTARG};;
    esac
done

dir="$(echo "${dir}" | sed -r "s#/?\$##")"
snaps="$(ls ${dir} -t -w 1)"
paths="$(echo "${snaps}" | sed -r "s#^#${dir}/#")"
paths="$(echo "${paths}" | sed -r "\#${dir}/${name}#!d")"
paths="$(echo "${paths}" | sort -r -n)"
paths="$(echo "${paths}" | tail "+$((keep + 1))")"

echo "$paths"

while IFS= read -r j
do
    # TODO Should the following check for emptyness be necessary?!
    if [ -z "${j}" ]
    then
        continue
    fi

    bcachefs subvolume delete "${j}"
done <<< "${paths}"
