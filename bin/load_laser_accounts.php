#!/usr/bin/php
<?php namespace ProcessWire; 
include("./index.php");

function randomPass() {
  $length = 16;
  $keys = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  return substr(str_shuffle($keys),0,$length);
}

function dateString($dateString) {
  $d = date_parse($dateString);
  return $d['year'] . "-" . $d['month'] . "-" . $d['day'] . " 00:00:00";
}

// CSV FORMATTING
// 0: First Name
// 1: Last Name
// 2: Display Name
// 3: Email
// 4: Gatorlink
// 5: UFID
// 6: College
// 7: Expiration

function createUser($pieces) {
  $u = wire('users')->get("lab_user_ufid=$pieces[5]");

  if (!$u->id) {
    $u = new User();
  }

  $u->of(false);
  $u->name                     = $pieces[5];
  $u->lab_user_first_name      = $pieces[0];
  $u->lab_user_last_name       = $pieces[1];
  $u->email                    = $pieces[3];
  $u->lab_user_expiration_date = dateString($pieces[7]);
  $u->lab_user_ufid            = $pieces[5];
  $u->pass                     = randomPass();

  $u->addRole("guest");
  $u->addRole("laser-user");

  $saved = $u->save();
  if($saved) {
    return true;
  }
  else {
    return false;
  }
}

$users = wire('users')->find('roles=laser-user');

echo("Adding laser users from CSV file.");
echo("<br/>\n");

// CSV FORMATTING
// 0: First Name
// 1: Last Name
// 2: Display Name
// 3: Email
// 4: Gatorlink
// 5: UFID
// 6: College
// 7: Expiration

$handle = fopen("data.csv", "r");
if ($handle) {
    while (($line = fgets($handle)) !== false) {
      $pieces = str_getcsv($line, ",", '"');
      $pieces[5] = str_replace('"', "", $pieces[5]);
      $pieces[7] = str_replace('"', "", $pieces[7]);

      if($pieces[5] != "" && $pieces[5] != "UFID") {
        $status = createUser($pieces);

        if($status) {
          echo("Added $pieces[2] to scheduler.");
          echo("<br/>\n");
        }
        else {
          echo("ERROR: Could not add $pieces[2] to scheduler.");
          echo("<br/>\n");
        }
      }
    }

    fclose($handle);
    unlink("data.csv");
} else {
  echo "Error opening file.";
} 


