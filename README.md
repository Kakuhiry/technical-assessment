## 🏢 Infrastructure
- Terraform:
    * google_compute_instance
    * google_secret_manage_secret
- dockerfile
- docker-compose
- nginx

Using Terraform, we create a e2-medium Virtual Machine running a Ubuntu_2004 system, and once created gets provisioned by `startup.sh` script, which install all the needed dependencies and required programs to work, then pulls the repo and starts the application using `docker-compose`, which runs two replicas of the application behind an `nginx` Load Balancer. After it’s created, the IP of the VM will be stored in a secret in Google’s Secret Manager, which will be useful to later use that secret and SSH into the VM with Github Actions.


## 📝 Application
- NodeJS
- JWT

The application was done using Nodejs, which receives a POST type request to the `/DevOps` endpoint. If the JWT matches the provided payload, and the API-Key is also provided, then the response will be a greeting to the user. Sending the wrong Payload will result in a validation error, and all other endpoints are disabled and will just return the string “ERROR”.

## ♻️ CI/CD
- Github Actions
- Docker build & push
- Conventional Commits
- Semantic Versioning
- Google Artifact Registry
- GitOps
- SSH
- Secret Manager



### 🧪 Testing pipeline:

Every time there’s a new `pull_request` attempting to merge into Develop, a pipeline will run to validate the PR title follows Conventional Commits norm.

### 🚀 Deployment pipeline:
When there’s a push to the main/master, a pipeline runs which releases a new `Semver` version (patch, feat, major releases) of the application based on the commit message that must follow conventional commits, then creates a Docker image using the released version as tag and it’s then pushed to Google’s Container Registry.

Once the release to GCR is done, another Github Actions step runs that pulls the IP of the host deployed by Terraform from Google Secret Manger, then connects into it via SSH, inside the VM changes the version of the app in the `docker-compose.yml` to the latests release and starts again.
