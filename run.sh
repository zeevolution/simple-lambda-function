## This script holds the necessary steps for creating an aws lambda
## function for a specific iam role. You may execute command separately
## on your favorite shell.

# 1st step: make sure you have the policy.json file created.

# 2nd step: create the iam role.
aws iam create-role \
  --role-name lambda-exemplo \
  --assume-role-policy-document file://policy.json \
  | tee logs/role.log

# 3rd step: gerenate a zip file for your index.js
zip function.zip index.js

# 4th step: create the lambda function for the zip file.
aws lambda create-function \
  --function-name hello-cli \
  --zip-file fileb://function.zip \
  --handler index.handler \
  --runtime nodejs12.x \
  --role arn:aws:iam::311971054159:role/lambda-exemplo \
  | tee logs/lambda-create.log
  
# 5th step: invoke the lambda function
aws lambda invoke \
  --function-name hello-cli \
  --log-type Tail \
  logs/lambda-exec.log

# -- For index.js updates, you must recreate the compress file.
zip function.zip index.js

# -- Next, update the lambda function.
aws lambda update-function-code \
  --zip-file fileb://function.zip \
  --function-name hello-cli \
  --publish \
  | tee logs/lambda-update.log

# -- Then, invoke the newly updated function.
aws lambda invoke \
  --function-name hello-cli \
  --log-type Tail \
  logs/lambda-exec-update.log

# 6th step: delete the lambda function
aws lambda delete-function \
  --function-name hello-cli

# 7th step: delete the iam role
aws iam delete-role \
  --role-name lambda-exemplo