RSpec.describe "Admin::V1::SystemRequirements as: :client" do
  let(:user) { create(:user, profile: :client) }
  let!(:system_requirement) { create(:system_requirement) }

  context "GET #index" do
    before { get admin_v1_system_requirements_path, headers: auth_header(user) }

    let!(:system_requirements) { create_list(:system_requirement, 5) }

    include_examples "forbidden access"
  end

  context "POST #create" do
    before{ post admin_v1_system_requirements_path, headers: auth_header(user) }

    include_examples "forbidden access"
  end

  context "PATCH #update" do
    before { patch admin_v1_system_requirement_path(system_requirement), headers: auth_header(user) }

    include_examples "forbidden access"
  end

  context "DELETE #destroy" do
    before { delete admin_v1_system_requirement_path(system_requirement), headers: auth_header(user) }

    include_examples "forbidden access"
  end
end
