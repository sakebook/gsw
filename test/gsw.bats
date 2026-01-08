#!/usr/bin/env bats

setup() {
  # Mock gcloud command
  function gcloud() {
    case "$*" in
      "config configurations list"*)
        echo "NAME        IS_ACTIVE  ACCOUNT            PROJECT"
        echo "prod        True       admin@company.com  prod-project"
        echo "dev         False      user@company.com   dev-project"
        ;;
      *)
        echo "gcloud $*"
        ;;
    esac
  }
  export -f gcloud

  # Mock 'command -v gcloud' to return success by default in tests
  function command() {
    if [[ "$1" == "-v" && "$2" == "gcloud" ]]; then
      return 0
    fi
    builtin command "$@"
  }
  export -f command

  # Source the script
  source ./gsw.sh
}

@test "gsw sets CLOUDSDK_ACTIVE_CONFIG_NAME by default" {
  gsw "test-config"
  [ "$CLOUDSDK_ACTIVE_CONFIG_NAME" = "test-config" ]
}

@test "gsw -g calls gcloud config configurations activate" {
  run gsw -g "test-config"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Switched GLOBALLY" ]]
  [[ "$output" =~ "gcloud config configurations activate test-config" ]]
}

@test "gsw --global calls gcloud config configurations activate" {
  run gsw --global "test-config"
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Switched GLOBALLY" ]]
}

@test "gsw with no args shows available configs and highlights active session" {
  export CLOUDSDK_ACTIVE_CONFIG_NAME="dev"
  run gsw
  [ "$status" -eq 0 ]
  [[ "$output" =~ "* dev" ]] && [[ "$output" =~ "(session active)" ]]
  [[ "$output" =~ "  prod" ]]
}

@test "gsw with no args show available configs without session highlight" {
  unset CLOUDSDK_ACTIVE_CONFIG_NAME
  run gsw
  [ "$status" -eq 0 ]
  [[ "$output" =~ "  prod        True       admin@company.com  prod-project" ]]
  [[ "$output" =~ "  dev         False      user@company.com   dev-project" ]]
}

@test "gsw rejects invalid configuration names (Security)" {
  run gsw "config; rm -rf /"
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Error: Invalid configuration name" ]]

  run gsw "dangerous\$(id)"
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Error: Invalid configuration name" ]]
}

@test "gsw --version outputs version" {
  run gsw --version
  [ "$status" -eq 0 ]
  [[ "$output" =~ "gsw version v"[0-9]+\.[0-9]+\.[0-9]+ ]]
}

@test "gsw --help shows usage with flags" {
  run gsw --help
  [ "$status" -eq 0 ]
  [[ "$output" =~ "-g, --global" ]]
}

@test "gsw returns error for unknown option" {
  run gsw --unknown
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Error: Unknown option" ]]
}

@test "gsw returns error for non-existent config" {
  # Mock failure for 'describe'
  function gcloud() {
    if [[ "$*" =~ "describe" ]]; then
      return 1
    fi
    echo "gcloud $*"
  }
  export -f gcloud
  
  run gsw "invalid-config"
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Error: Configuration 'invalid-config' does not exist" ]]
}

@test "gsw returns error if gcloud is not installed" {
  # Mock 'command -v gcloud' failure
  function command() {
    if [[ "$1" == "-v" && "$2" == "gcloud" ]]; then
      return 1
    fi
    builtin command "$@"
  }
  export -f command

  run gsw
  [ "$status" -eq 1 ]
  [[ "$output" =~ "Error: 'gcloud' command not found" ]]
  
  unset -f command
}
