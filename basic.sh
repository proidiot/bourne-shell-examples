#!/bin/sh
set -eu

# NOTE: It is useful to create most of the variables here so that they can be
# overridden with flags and potentially have their default values displayed
# within the help message. Unfortunately, variables whose default values are
# based on the (potentially user settable) values of other variables can
# complicate matters significantly, but that is out of scope for this simple
# example shell script.
DEBUG='FALSE'
MAINTAINER='Charlie'
MESSAGE='Hello, shell!'
VERSION='0.0.1'

# NOTE: This loop eats arguments one at a time, so it is necessary to save any
# flag or argument into variables.
while [ $# -gt 0 ]; do
	case "$1" in
	-h|--help)
		# NOTE: In order to see what the help message looks like in 80
		# columns, I have not used the generally preferrable indented
		# heredoc (i.e. '<<-_FOO_ ').
		cat <<_HELP_
Usage: ${0} [ OPTIONS ]

${0} ${VERSION}
An example Bourne shell script whose source code is (hopefully) easy to
understand.

Available options:
	-h, --help
		Prints this message.

	-m, --message STRING
		Sets the message to be printed.
		Default: ${MESSAGE}

	--version
		Prints the version of this script.

	--debug
		Enables debugging of this script.

For additional questions or to report bugs, please contact ${MAINTAINER}.
_HELP_
		# NOTE: If we are being asked to display the help message, we
		# should prevent anything else from happening.
		exit 0
		;;
	-m|--message)
		# NOTE: At the end of the argument-consuming loop, we already
		# have a 'shift' call, but this particular flag takes an
		# argument, so we need another 'shift' here instead of reading
		# from '${2}' in order to assure that the argument is not later
		# mistaken for another flag being passed.
		shift
		MESSAGE="${1}"
		;;
	--version)
		cat <<-_VERSIONMSG_
		${0} ${VERSION}
		_VERSIONMSG_
		# NOTE: If we are being asked to display the version message, we
		# should prevent anything else from happening.
		exit 0
		;;
	--debug)
		set -x
		DEBUG='TRUE'
		;;
	*)
		cat >&2 <<-_UNKNOWN_
		Error: Unknown option: ${1}
		See ${0} --help for a list of valid options.
		_UNKNOWN_
		exit 1
	esac
	# NOTE: It is assumed that after this 'shift' is run, either all the
	# arguments have been read or the next argument is a new flag. If this
	# behavior needs to change, a modification would likely need to be made
	# both here and in the guard of the 'while' loop.
	shift
done

# NOTE: Presumably you would want to do something more useful than this in a
# real script.
echo "${MESSAGE}"

