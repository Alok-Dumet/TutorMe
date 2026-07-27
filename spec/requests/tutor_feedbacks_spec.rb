require 'rails_helper'

RSpec.describe 'Tutor::Feedbacks', type: :request do
  let(:tutor) { create(:tutor) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_learner).and_return(tutor.learner)
    allow_any_instance_of(ApplicationController).to receive(:current_tutor).and_return(tutor)
  end

  describe 'GET /tutor/feedbacks' do
    it 'shows all feedback for the current tutor' do
      create(:feedback, tutor: tutor, comment: "Great job")
      get tutor_feedbacks_path
      expect(response.body).to include("Great job")
    end

    it 'prevents viewing another tutor\'s feedback' do
      other = create(:tutor)
      get tutor_feedbacks_path, params: { tutor_id: other.id }
      expect(response).to redirect_to(tutor_feedbacks_path)
      expect(flash[:alert]).to eq('Access denied')
    end
  end
end