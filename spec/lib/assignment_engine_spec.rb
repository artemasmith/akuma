require 'rails_helper'

RSpec.describe AssignmentEngine do
  let(:service) { described_class }

  context 'when ok' do
    let(:user1) { User.create(first_name: 'Mark', second_name: 'Lobster', email: 'test@test.com') }
    let(:user2) { User.create(first_name: 'Bark', second_name: 'Lobster', email: 'test1@test.com') }
    let(:user3) { User.create(first_name: 'Wark', second_name: 'Lobster', email: 'test2@test.com') }
    let(:category1) { Category.create(title: '1', description: 'customer problem to solve') }
    let(:category2) { Category.create(title: '2', description: 'customer problem to solve') }
    let(:category3) { Category.create(title: '3', description: 'customer problem to solve') }
    let!(:issue1) do
      Issue.create(title: 'issue_1',
                   description: 'this first issue for test',
                   issue_type: 'error',
                   creator: 'system',
                   category: category1)
    end
    let!(:issue2) do
      Issue.create(title: 'issue_2',
                   description: 'this first issue for test',
                   issue_type: 'error',
                   creator: 'system',
                   category: category2)
    end
    let!(:issue3) do
      Issue.create(title: 'issue_3',
                   description: 'this first issue for test',
                   issue_type: 'error',
                   creator: 'system',
                   category: category3)
    end
    let!(:issue4) do
      Issue.create(title: 'issue_4',
                   description: 'this first issue for test',
                   issue_type: 'error',
                   creator: 'system',
                   category: category1)
    end
    let!(:issue5) do
      Issue.create(title: 'issue_5',
                   description: 'this first issue for test',
                   issue_type: 'error',
                   creator: 'system',
                   category: category1)
    end

    context 'when round robin users' do
      before do
        issue1.update(created_at: Date.yesterday)
        issue5.update(created_at: Date.yesterday - 1.day)
        user1.categories << category1
        user2.categories << category1
        user3.categories << category1

        service.call
      end

      it 'assign in proper order' do
        expect(Issue.unassigned.count).to eq(2)
        expect(issue5.reload.user).to eq(user1)
        expect(issue1.reload.user).to eq(user2)
        expect(issue4.reload.user).to eq(user3)
      end
    end

    context 'when we assign all issues' do
      before do
        user1.categories << category1
        user2.categories << category2
        user3.categories << category3

        service.call
      end

      it 'assign it all' do
        expect(Issue.unassigned.count).to eq(0)
      end
    end
    describe '.assign' do
      context 'when only one user in category' do
        before do
          user1.categories << category1
          service.assign(issue1)
        end

        it 'assign user1' do
          expect(issue1.reload.user).to eq(user1)
        end
      end
      context 'when multiple category users' do
        before do
          user1.categories << category1
          user2.categories << category1
          user3.categories << category2
        end

        it 'assign random category user' do
          service.assign(issue1)
          expect([user1, user2]).to include(issue1.reload.user)
        end

        it 'reassign works' do
          service.assign(issue1)
          updated_at = issue1.updated_at
          100.times do
            service.assign(issue1)
          end
          expect([user1, user2]).to include(issue1.reload.user)
          expect(issue1.updated_at).not_to eq(updated_at)
        end
      end

      context 'when no category users' do
        before do
          user1
          user2
          user3
          service.assign(issue1)
        end

        it { expect(issue1.reload.user).not_to be_blank }
      end

      context 'when incorrect input' do
        it 'no users at all' do
          service.assign(issue1)
          expect(issue1.reload.user).to be_blank
        end

        it 'incorrect object sent' do
          expect{ service.assign(user1) }.to raise_error(NoMethodError)
        end
      end
    end
  end

  context 'when no issues' do
    it 'just do nothing' do
      expect { service.call }.not_to raise_error
    end
  end
end
