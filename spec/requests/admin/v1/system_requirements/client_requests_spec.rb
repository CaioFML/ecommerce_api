RSpec.describe Admin::V1::SystemRequirementsController do
  context "with user client" do
    let(:user) { create(:user, profile: :client) }
    let!(:system_requirement) { create(:system_requirement) }

    describe "GET #index" do
      before do
        create_list(:system_requirement, 5)

        get admin_v1_system_requirements_path, headers: auth_header(user)
      end

      include_examples "forbidden access"
    end

    describe "POST #create" do
      before { post admin_v1_system_requirements_path, headers: auth_header(user) }

      include_examples "forbidden access"
    end

    describe "PATCH #update" do
      before { patch admin_v1_system_requirement_path(system_requirement), headers: auth_header(user) }

      include_examples "forbidden access"
    end

    describe "DELETE #destroy" do
      before { delete admin_v1_system_requirement_path(system_requirement), headers: auth_header(user) }

      include_examples "forbidden access"
    end
  end
end
