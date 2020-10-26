locals {
  lambda_submit = ["./agents/ejemplo1.py", "./agents/ejemplo2.py"]
  lambda_result = ["./agents/ejemplo3.py"]
}



resource "local_file" "to_submit" {
  count    = length(local.lambda_submit)
  filename = "./lambda-submit/${basename(element(local.lambda_submit, count.index))}"
  content = templatefile(element(local.lambda_submit,count.index),{})
  //content  = element(data.template_file.t_file_submit.*.rendered, count.index)
}

data "archive_file" "lambda_submit" {
  type        = "zip"
  output_path = "lambda-submit.zip"
  source_dir  = "./lambda-submit"

  depends_on = [
    local_file.to_submit
  ]
}


///////////


resource "local_file" "to_result" {
  count    = length(local.lambda_result)
  filename = "./lambda-result/${basename(element(local.lambda_result, count.index))}"
  content  = templatefile(element(local.lambda_result,count.index),{})
}

data "archive_file" "lambda_result" {
  type        = "zip"
  output_path = "lambda-result.zip"
  source_dir  = "./lambda-result"

  depends_on = [
    local_file.to_result
  ]
}