RSpec.describe Admin::V1::SystemRequirementsController do
  context "with user admin" do
    let(:user) { create(:user) }
    let(:system_requirement_attributes) { %i[id name operational_system storage processor memory video_board] }

    describe "GET #index" do
      subject(:get_index) { get admin_v1_system_requirements_path, headers: auth_header(user) }

      let!(:system_requirement) { create_list(:system_requirement, 5) }

      it "returns all system requirements" do
        get_index

        expect(body_json["system_requirements"])
          .to contain_exactly(*system_requirement.as_json(only: system_requirement_attributes))
      end

      it do
        get_index

        expect(response).to have_http_status :ok
      end
    end

    describe "POST #create" do
      subject(:post_create) { post admin_v1_system_requirements_path, headers: auth_header(user), params: params }

      context "with valid params" do
        let(:params) { { system_requirement: attributes_for(:system_requirement) }.to_json }

        it "adds a new SystemRequirement" do
          expect { post_create }.to change(SystemRequirement, :count).by(1)
        end

        it "returns last added SystemRequirement" do
          post_create

          expect(body_json["system_requirement"])
            .to eq SystemRequirement.last.as_json(only: %i[
                                                    id name operational_system storage processor memory video_board
                                                  ])
        end

        it do
          post_create

          expect(response).to have_http_status(:ok)
        end
      end

      context "with invalid params" do
        let(:params) { { system_requirement: attributes_for(:system_requirement, name: nil) }.to_json }

        it "does not add a new SystemRequirement" do
          expect { post_create }.not_to change(SystemRequirement, :count)
        end

        it "returns error message" do
          post_create

          expect(body_json["errors"]["fields"]).to have_key("name")
        end

        it do
          post_create

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "PATCH #update" do
      subject(:patch_update) do
        patch admin_v1_system_requirement_path(system_requirement), headers: auth_header(user), params: params
      end

      let(:system_requirement) { create(:system_requirement) }

      context "with valid params" do
        let(:new_name) { "My new SystemRequiment" }
        let(:params) { { system_requirement: { name: new_name } }.to_json }

        it "updates SystemRequirement" do
          patch_update

          expect(system_requirement.reload.name).to eq new_name
        end

        it "returns updated SystemRequirement" do
          patch_update

          expect(body_json["system_requirement"])
            .to eq system_requirement.reload.as_json(only: system_requirement_attributes)
        end

        it do
          patch_update

          expect(response).to have_http_status(:ok)
        end
      end

      context "with invalid params" do
        let(:params) { { system_requirement: attributes_for(:system_requirement, name: nil) }.to_json }

        it "does not update SystemRequirement" do
          old_name = system_requirement.name

          patch_update

          system_requirement.reload
          expect(system_requirement.name).to eq old_name
        end

        it "returns error message" do
          patch_update

          expect(body_json["errors"]["fields"]).to have_key("name")
        end

        it do
          patch_update

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "DELETE #destroy" do
      subject(:destroy) { delete admin_v1_system_requirement_path(system_requirement), headers: auth_header(user) }

      let!(:system_requirement) { create(:system_requirement) }

      it "removes SystemRequirement" do
        expect { destroy }.to change(SystemRequirement, :count).by(-1)
      end

      it do
        destroy

        expect(response).to have_http_status(:no_content)
      end

      it "does not return any body content" do
        destroy

        expect(body_json).not_to be_present
      end
    end
  end
end
