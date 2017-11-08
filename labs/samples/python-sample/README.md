# Cloud Foundry sample application for Flask
## About this application
This is a sample application to deploy Flask application for Cloud Foundry (CF).

## Environment to run
- Cloud Foundry (Diego) or the version which Buildpack available

## How to run

1. Make sure that you have already logged into CF with [cf_cli](http://docs.cloudfoundry.org/cf-cli/install-go-cli.html "Installing the cf Command Line Interface").
2. Run `$ cf push <yourapp>`
3. Go to your application URL. `http://yourapp.example.com/` just shows "Hello world", and `http://yourapp.example.com/vars/` shows the available environment variables on CF

<img src="https://raw.githubusercontent.com/yuta-hono/flask-cloudfoundry-sample/images/cf_vars.png" width="440 px">

4. Just an example, if you access to `http://yourapp.example.com/ip/` you can see the demo of source IP access restriction in application level. Allowed source IP is configured in `hello.py` as `allowed_ip`

## Files

### Files to declare runtime envinronment

#### requirements.txt
Pip requirements, this automatically satisfied by CF in a staging phase.

#### runtime.txt
The file specifies Python version to run this application by CF.
See more details at [Python Buildpack](https://docs.cloudfoundry.org/buildpacks/python/index.html "Python Buildpack").

#### manifest.yml
The file specifies about the specs of instance (memory/disk quota, etc).

#### Procfile
The file specify what commands run the application.
This also can specified in a deploy command with `-c` option.
For more details, see at [Binary Buildpack](http://docs.cloudfoundry.org/buildpacks/binary/index.html "Binary Buildpack").

#### .profile.d/*
The directory include the scripts executed in the phase of application deployment.
You can specify `.sh` extention file to declare your own environemental variables. In this sample code, the env var `MY_OWN_ENV_VAR` is declared in `setenv.sh`.
Fore more details, see at [Set Environment Variables
](https://docs.cloudfoundry.org/devguide/deploy-apps/deploy-app.html#profiled "Set Environment Variables").

#### .cfignore
The file declares the files which would not require to be built as an application. The file type (name rule) specified into this file will be ignores in build phase and not included to deployed application. The rules to specify file types follow to [.gitignore template](https://github.com/github/gitignore).

You can confirm that what is happened to your deployed application with changing this `.cfignore` rule. For example, just deploy this sample code as is, you can not find "LICENSE" file on the deployed application on CF.

```bash
$ cf ssh <app_name>
```

After running this command, you will login to the container which the app running.

```bash
vcap@gisoujblbc5:~$ ls
app  logs  staging_info.yml  tmp
```

If you login to `app` dir , you will see the deployed application files. Since `LICENSE` file is configured to be ignored, it is not on the container.

```bash
vcap@gisoujblbc5:~$ cd app
vcap@gisoujblbc5:~/app$ ls
hello.py  Procfile   requirements.txt  templates
runtime.txt
```

If you remove the line of `LICENSE` from `.cfignore` and re-deploy that to CF, you will see that on the container.

```bash
vcap@gisoujblbc5:~$ cd app
vcap@gisoujblbc5:~/app$ ls
hello.py  Procfile   requirements.txt  templates
LICENSE runtime.txt
```

For more details, see [Ignore Unnecessary Files When Pushing](https://docs.cloudfoundry.org/devguide/deploy-apps/prepare-to-deploy.html#exclude "Ignore Unnecessary Files When Pushing").

### Web application files

#### hello.py , templates/*
The simple Flask application run on CF.
Important things here are:

- App `host` requires to be set as "0.0.0.0"
  - CF routes the traffic from external in the router, and since all the component is scalable, CF can not restrict the access with source IPs 
- App `port` requires to be set with dynamic value comes from CF envinronmental value
  - Since the port is dynamic value, an application can not specify a static port number. This port number requires to be set with dynamic value also

And CF gives you a some useful environmental variables, you can check the environmetal variables from `http://yourapp.example.com/vars/`. Also, it gives you custom header prefixed with `X-` (ex. `X-Forwarded-Proto`, `X-Forwarded-For`) . You can use this to restrict HTTP protocol, get source IP logs, restrict the access with source IPs in application level. In this sample code, source IP restriction is implemented as `http://yourapp.example.com/ip/`.

For more details of HTTP headers, please refer [HTTP header](https://docs.cloudfoundry.org/devguide/deploy-apps/prepare-to-deploy.html#http-headers).
Details of environmental variables, please refer [Cloud Foundry Environment Variables](http://docs.cloudfoundry.org/devguide/deploy-apps/environment-variable.html "Cloud Foundry Environment Variables")