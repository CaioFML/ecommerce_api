RSpec.describe "Admin::V1::SystemRequirements without authentication" do
  context "GET #index" do
    before { get admin_v1_system_requirements_path }

    let!(:categories) { create_list(:category, 5) }

    include_examples "unauthenticated access"
  end

  context "POST #create" do
    before { post admin_v1_system_requirements_path }

    include_examples "unauthenticated access"
  end

  context "PATCH #update" do
    before { patch admin_v1_system_requirement_path(system_requirement) }

    let(:system_requirement) { create(:system_requirement) }

    include_examples "unauthenticated access"
  end

  context "DELETE #destroy" do
    before { delete admin_v1_system_requirement_path(system_requirement) }

    let!(:system_requirement) { create(:system_requirement) }

    include_examples "unauthenticated access"
  end
end
