package test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestECSServiceBasic(t *testing.T) {
	t.Parallel()

	//Expected Value
	expectedName := fmt.Sprintf("nginx-%s", strings.ToLower(random.UniqueId()))

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/basic",
		Upgrade:      true,

		// Variables to pass to ourt Terrraform code using -var options
		Vars: map[string]interface{}{
			"app_name": expectedName,
		},

		// Environment variables to set when running Terraform
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": "us-east-2",
		},
	}
	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	appName := terraform.Output(t, terraformOptions, "app_name")
	assert.Equal(t, expectedName, appName)

}
