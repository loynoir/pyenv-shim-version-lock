#!/bin/bash
(
	set -eo pipefail
	[ -z "${DEBUG:-}" ] || set -x
	if [ -v BASH_SOURCE ]; then
		__filename="${BASH_SOURCE[0]}"
	else
		#FIXME: shfmt workaround
		eval '__filename="${(%):-%x}"'
	fi
	__filename="$(realpath -m "${__filename}")"
	__dirname="$(dirname "${__filename}")"
	readonly __filename
	readonly __dirname
	cd "${__dirname}" || exit 1
	cd .. || exit 1

	# shellcheck disable=SC1091
	source src/index.sh
	: "$(type pin_declaration)"

	tmpd="$(mktemp -d)"
	cd "$tmpd" || exit 1

	echo -n $'foo=bar\nexec foobar' >expected
	echo -n $'exec foobar' >actual
	insert_before_ere '^exec' actual <<<'foo=bar'
	echo ">>> insert_before_ere no LF"
	diff -u actual expected

	echo -n $'foo=bar\nexec foobar\n' >expected
	echo -n $'exec foobar\n' >actual
	insert_before_ere '^exec' actual <<<'foo=bar'
	echo ">>> insert_before_ere last"
	diff -u actual expected

	echo -n $'foo=bar\nexec foobar\nbar=foo' >expected
	echo -n $'exec foobar\nbar=foo' >actual
	insert_before_ere '^exec' actual <<<'foo=bar'
	echo ">>> insert_before_ere not last"
	diff -u actual expected

	# shellcheck disable=SC2034
	a=a1
	# shellcheck disable=SC2034
	b=b1
	echo -n $'export a="a1"\nexport b="b1"\n' >expected
	export_declaration a b >actual
	echo ">>> export_declaration"
	diff -u actual expected

	unset c
	echo -n $'export a="a1"\nexport b="b1"\nexport c=""\n' >expected
	export_declaration a b c >actual
	echo ">>> export_declaration empty"
	diff -u actual expected

	echo ">>> ALL TEST PASSED"
	exit 0
)
