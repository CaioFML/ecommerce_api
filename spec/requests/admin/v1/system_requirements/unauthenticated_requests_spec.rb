RSpec.describe Admin::V1::SystemRequirementsController do
  context "without authentication" do
    describe "GET #index" do
      before do
        create_list(:category, 5)

        get admin_v1_system_requirements_path
      end

      include_examples "unauthenticated access"
    end

    describe "POST #create" do
      before { post admin_v1_system_requirements_path }

      include_examples "unauthenticated access"
    end

    describe "PATCH #update" do
      before { patch admin_v1_system_requirement_path(system_requirement) }

      let(:system_requirement) { create(:system_requirement) }

      include_examples "unauthenticated access"
    end

    describe "DELETE #destroy" do
      before { delete admin_v1_system_requirement_path(system_requirement) }

      let!(:system_requirement) { create(:system_requirement) }

      include_examples "unauthenticated access"
    end
  end
end
