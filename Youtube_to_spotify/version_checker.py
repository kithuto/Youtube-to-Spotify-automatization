import sys
from program_version import version

git_version = sys.argv[1]

if git_version != version:
    print("Version "+git_version[1:]+" available!")
    print("Do you want to install this new version (y/n)?")
    response = input()
    if response == "y":
        sys.exit(1)
    else:
        sys.exit(2)
else:
    sys.exit(0)