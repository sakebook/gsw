#!/usr/bin/env bats

setup() {
  # Mock gcloud command
  function gcloud() {
    echo "gcloud $*"
  }
  export -f gcloud

  # Source the script (assuming Zsh for now, but BATS runs in Bash usually. 
  # Since our script is currently Zsh-only, we might need to test strictly in Zsh 
  # or make the script compatible first.
  # HOWEVER, the current script is mostly POSIX compatible except for completion.
  # We will test the basic functions which SHOULD work in simple Bash unless zsh-specifics are hit.
  
  # To properly test Zsh functions, we usually need to run bats with Zsh or invoke zsh.
  # For simplicity in this initial "minimum" test, we will check if it source-able in Bash.
  # If it fails, that confirms we need the refactor! 
  
  # Actually, let's load it. The array syntax in _gsw might fail in Bash, 
  # but the functions gsw/gsw-local should be fine.
  source ./gsw.sh || true # Ignore errors specifically for the non-bash parts for now
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

@test "gsw with no args shows usage with session info" {
  run gsw
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Default switches only for this terminal session" ]]
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
  [[ ! "$output" =~ "gcloud config configurations list" ]]
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
