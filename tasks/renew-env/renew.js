var system = require('system');
var webpage = require('webpage');

phantom.onError = function(msg, trace) {
  var msgStack = ['PHANTOM ERROR: ' + msg];
  if (trace && trace.length) {
    msgStack.push('TRACE:');
    trace.forEach(function(t) {
      msgStack.push(' -> ' + (t.file || t.sourceURL) + ': ' + t.line + (t.function ? ' (in function ' + t.function +')' : ''));
    });
  }
  console.log(msgStack.join('\n'));
  phantom.exit(1)
}

function startNextRenew(envIndex, envTotal) {
  if (envIndex >= envTotal) {
    console.log("All "+ envTotal +" environments renewed! \n");
    phantom.exit();
  }

  env = environments[envIndex];
  var url = "https://environments.toolsmiths.cf-app.com/gcp_engineering_environment_renew?id="+env.ID;

  console.log("Starting to renew " + env.name + "\t\t with ID: " + env.ID + "\n");
  console.log(url + "\n");

  var page = webpage.create();
  page.open(url, function (status) {
    if(status === "success") {
      window.setTimeout(function () {
              console.log("                  " + env.name + "\t\t with ID: " + env.ID +"\t - " + document.readyState+ "\n");
              startNextRenew(envIndex+1, envTotal)
          }, 1000);
    } else {
      console.log("Page: " + url + " failed to load with status: " + status + "\n");
      startNextRenew(envIndex+1, envTotal)
    }
  });
}

raw_environments = system.env['ENVIRONMENTS']

if (raw_environments == null) {
  console.error("env var $ENVIRONMENTS is required")
  phantom.exit(1);
}

environments = JSON.parse(raw_environments)
envTotal = Object.keys(environments).length;

console.log("Attempting to renew "+ envTotal +" environments: \n");

startNextRenew(0, envTotal);
