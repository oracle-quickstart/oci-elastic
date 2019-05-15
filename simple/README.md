# simple
Terraform module that deploys Elasticsearch, Kibana, and Logstash on a VM.

## Prerequisites
First off you'll need to do some pre deploy setup.  That's all detailed [here](https://github.com/oracle/oci-quickstart-prerequisites).

## Clone the Module
Now, you'll want a local copy of this repo.  You can make that with the commands:

    git clone https://github.com/oracle/oci-quickstart-elastic.git
    cd oci-elastic/simple
    ls

That should give you this:

![](../images/simple/git-clone.png)

## Initialize the deployment
Pick a module and change into the directory containing it (enterprise or community).

We now need to initialize the directory with the module in it.  This makes the module aware of the OCI provider.  You can do this by running:

    terraform init

This gives the following output:

![](../images/simple/terraform-init.png)

## Deploy the module
Now for the main attraction.  Let's make sure the plan looks good:

    terraform plan

That gives:

![](../images/simple/terraform-plan.png)

If that's good, we can go ahead and apply the deploy:

    terraform apply

You'll need to enter `yes` when prompted.  Once complete, you'll see something like this:

![](../images/simple/terraform-apply.png)

When the apply is complete, the infrastructure will be deployed, but cloud-init scripts will still be running.  Those will wrap up asynchronously.  So, it'll be a few more minutes before your cluster is accessible.  Now is a good time to get a coffee.


## Connect to Elasticsearch
When the module is deployed, you will see an output that shows the ELK VM public IP.

Example:

`ELK VM public IP = 132.145.139.235`

Create an SSH tunnel for ports `9200` and `5601` with the following command:

`ssh -L 9200:localhost:9200 -L 5601:localhost:5601 opc@<ELK VM public IP`

Now you can browse to (http://localhost:9200) for Elasticsearch, and (http://localhost:5601) for Kibana.

![](../images/simple/elasticsearch.png)

![](../images/simple/kibana.png)

## SSH to a Node
These machines are using Oracle Enterprise Linux (OEL).  The default login is opc. You can SSH into the machine with a command like this:

    ssh opc@<Public IP Address>

## View the Cluster in the Console
You can also login to the web console [here](https://console.us-phoenix-1.oraclecloud.com/a/compute/instances) to view the IaaS that is running the cluster.

![](../images/simple/console.png)

## Destroy the Deployment
When you no longer need the deployment, you can run this command to destroy it:

    terraform destroy

You'll need to enter `yes` when prompted.

![](../images/simple/terraform-destroy.png)
