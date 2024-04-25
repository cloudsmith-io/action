#!/usr/bin/env bats
load 'libs/bats-support/load'
load 'libs/bats-assert/load'

profile_script="${BATS_TEST_DIRNAME}/../entrypoint.sh"

function setup_mocks {
    function cloudsmith() { echo "EXECUTE cloudsmith ${@}"; }
    export -f cloudsmith

    function pip() { echo "EXECUTE pip ${@}"; }
    export -f pip
}


@test ".only push command is supported" {
    setup_mocks
    run $profile_script -K foo
    assert_failure
    assert_output -p "Command foo is not supported!"
}

@test ".format is a required argument" {
    setup_mocks
    run $profile_script
    assert_failure
    assert_output -p "format is required"
}

@test ".owner is a required argument" {
    setup_mocks
    run $profile_script -f raw
    assert_failure
    assert_output -p "owner is required"
}

@test ".repo is a required argument" {
    setup_mocks
    run $profile_script -f raw -o my-org
    assert_failure
    assert_output -p "repo is required"
}

@test ".file is a required argument" {
    setup_mocks
    run $profile_script -f raw -o my-org -r my-repo
    assert_failure
    assert_output -p "file is required"
}

@test ".distro is a required argument, for debian" {
    setup_mocks
    run $profile_script -f deb -o my-org -r my-repo -F package.deb
    assert_failure
    assert_output -p "distro is required"
}

@test ".release is a required argument, for debian" {
    setup_mocks
    run $profile_script -f deb -o my-org -r my-repo -F package.deb -d ubuntu
    assert_failure
    assert_output -p "release is required"
}

@test ".distro is a required argument, for redhat" {
    setup_mocks
    run $profile_script -f rpm -o my-org -r my-repo -F package.rpm
    assert_failure
    assert_output -p "distro is required"
}

@test ".release is a required argument, for redhat" {
    setup_mocks
    run $profile_script -f rpm -o my-org -r my-repo -F package.rpm -d el
    assert_failure
    assert_output -p "release is required"
}

@test ".distro is a required argument, for alpine" {
    setup_mocks
    run $profile_script -f alpine -o my-org -r my-repo -F package.apk
    assert_failure
    assert_output -p "distro is required"
}

@test ".release is a required argument, for alpine" {
    setup_mocks
    run $profile_script -f alpine -o my-org -r my-repo -F package.apk -d alpine
    assert_failure
    assert_output -p "release is required"
}

@test ".pom-file is a required argument, for maven" {
    setup_mocks
    run $profile_script -f maven -o my-org -r my-repo -F package.jar
    assert_failure
    assert_output -p "pom_file is required"
}

@test ".name is a required argument, for swift" {
    setup_mocks
    run $profile_script -f swift -o my-org -r my-repo -F package.zip -S my-scope -V 1.0.0
    assert_failure
    assert_output -p "name is required"
}

@test ".scope is a required argument, for swift" {
    setup_mocks
    run $profile_script -f swift -o my-org -r my-repo -F package.zip -n my-package -V 1.0.0
    assert_failure
    assert_output -p "scope is required"
}

@test ".version is a required argument, for swift" {
    setup_mocks
    run $profile_script -f swift -o my-org -r my-repo -F package.zip -S my-scope -n my-package
    assert_failure
    assert_output -p "version is required"
}

@test ".execute successful debian push" {
    setup_mocks
    run $profile_script -f deb -o my-org -r my-repo -F package.deb -d ubuntu -R xenial
    assert_success
    assert_output -p "EXECUTE cloudsmith push deb my-org/my-repo/ubuntu/xenial package.deb"
}

@test ".execute successful redhat push" {
    setup_mocks
    run $profile_script -f rpm -o my-org -r my-repo -F package.rpm -d el -R 7
    assert_success
    assert_output -p "EXECUTE cloudsmith push rpm my-org/my-repo/el/7 package.rpm"
}

@test ".execute successful alpine push" {
    setup_mocks
    run $profile_script -f alpine -o my-org -r my-repo -F package.apk -d alpine -R v3.8
    assert_success
    assert_output -p "EXECUTE cloudsmith push alpine my-org/my-repo/alpine/v3.8 package.apk"
}

@test ".execute successful dart push" {
    setup_mocks
    run $profile_script -f dart -o my-org -r my-repo -F package.dart
    assert_success
    assert_output -p "EXECUTE cloudsmith push dart my-org/my-repo package.dart"
}

@test ".execute successful docker push" {
    setup_mocks
    run $profile_script -f docker -o my-org -r my-repo -F package.docker
    assert_success
    assert_output -p "EXECUTE cloudsmith push docker my-org/my-repo package.docker"
}

@test ".execute successful helm push" {
    setup_mocks
    run $profile_script -f helm -o my-org -r my-repo -F package.tar.gz
    assert_success
    assert_output -p "EXECUTE cloudsmith push helm my-org/my-repo package.tar.gz"
}

@test ".execute successful hex push" {
    setup_mocks
    run $profile_script -f hex -o my-org -r my-repo -F package.tar
    assert_success
    assert_output -p "EXECUTE cloudsmith push hex my-org/my-repo package.tar"
}

@test ".execute successful python push" {
    setup_mocks
    run $profile_script -f python -o my-org -r my-repo -F package.whl
    assert_success
    assert_output -p "EXECUTE cloudsmith push python my-org/my-repo package.whl"
}

@test ".execute successful raw push" {
    setup_mocks
    run $profile_script -f raw -o my-org -r my-repo -F package.zip -n my-name -s "Some Summary" -D "Some Description" -V 1.0
    assert_success
    assert_output -p "EXECUTE cloudsmith push raw my-org/my-repo package.zip --name=my-name --summary=Some Summary --description=Some Description --version=1.0"
}

@test ".execute successful cargo push" {
    setup_mocks
    run $profile_script -f cargo -o my-org -r my-repo -F package.crate
    assert_success
    assert_output -p "EXECUTE cloudsmith push cargo my-org/my-repo package.crate"
}

@test ".execute successful npm push" {
    setup_mocks
    run $profile_script -f npm -o my-org -r my-repo -F package.tgz
    assert_success
    assert_output -p "EXECUTE cloudsmith push npm my-org/my-repo package.tgz"
}

@test ".execute successful nuget push" {
    setup_mocks
    run $profile_script -f nuget -o my-org -r my-repo -F package.nupkg
    assert_success
    assert_output -p "EXECUTE cloudsmith push nuget my-org/my-repo package.nupkg"
}

@test ".execute successful go push" {
    setup_mocks
    run $profile_script -f go -o my-org -r my-repo -F package.zip
    assert_success
    assert_output -p "EXECUTE cloudsmith push go my-org/my-repo package.zip"
}

@test ".execute successful maven push" {
    setup_mocks
    run $profile_script -f maven -o my-org -r my-repo -F package.jar -p package.pom
    assert_success
    assert_output -p "EXECUTE cloudsmith push maven my-org/my-repo package.jar --pom-file=package.pom"
}

@test ".execute successful swift push" {
    setup_mocks
    run $profile_script -f swift -o my-org -r my-repo -F package.zip -n my-package -V 1.0.0 -S my-scope
    assert_success
    assert_output -p "EXECUTE cloudsmith push swift my-org/my-repo package.zip --scope=my-scope --name=my-package --version=1.0.0"
}

@test ".execute successful other push, but reports unsupported" {
    setup_mocks
    run $profile_script -f other -o my-org -r my-repo -F package.unk
    assert_success
    assert_output -p "EXECUTE cloudsmith push other my-org/my-repo package.unk"
    assert_output -p "Format other is not yet officially supported"
}

@test ".execute successful push, with optional universal args" {
    setup_mocks
    run $profile_script -f deb -o my-org -r my-repo -F package.deb -d ubuntu \
        -R xenial -P true -w 10.0 -W true -- --verbatim-this 1 --verbatim-that 2
    assert_success
    assert_output -p "EXECUTE cloudsmith push deb my-org/my-repo/ubuntu/xenial package.deb --republish --wait-interval=10.0 --no-wait-for-sync --verbatim-this 1 --verbatim-that 2"
}

@test ".execute successful push, with optional universal args, none ignored" {
    setup_mocks
    run $profile_script -f deb -o my-org -r my-repo -F package.deb -d ubuntu \
        -R xenial -P none -w none -W none -- none
    assert_success
    assert_output -p "EXECUTE cloudsmith push deb my-org/my-repo/ubuntu/xenial package.deb"
}
