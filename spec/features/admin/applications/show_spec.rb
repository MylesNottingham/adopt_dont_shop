require "rails_helper"

RSpec.describe "Admin Application Show Page" do
  before(:each) do
    @application_1 = Application.create!(name: "Fredrich Longbottom",
                                        address: "1234 1st St",
                                        city: "Denver",
                                        state: "CO",
                                        zip: "80202",
                                        description_why: "I love creatures."
                                        )
    @application_2 = Application.create!(name: "Simon Duder",
                                        address: "1234 6st St",
                                        city: "Tacoma",
                                        state: "WA",
                                        zip: "98445",
                                        description_why: "I need a friend."
                                        )
    @shelter_1 = Shelter.create!(
      foster_program: false,
      name: "Denver Animal Shelter",
      city: "Denver",
      rank: 1
      )
    @pet_1 = @shelter_1.pets.create!(
      adoptable: true,
      age: 3,
      breed: "Jack Russell Terrier",
      name: "Alphonso",
      shelter_id: 1
      )

    @pet_2 = @shelter_1.pets.create!(
      adoptable: true,
      age: 4,
      breed: "Husky",
      name: "Bailey",
      shelter_id: 1
      )

    @pet_3 = @shelter_1.pets.create!(
      adoptable: true,
      age: 2,
      breed: "Great Dane",
      name: "Charlie",
      shelter_id: 1
      )

    @pet_4 = @shelter_1.pets.create!(
      adoptable: true,
      age: 5,
      breed: "Golden",
      name: "Doug",
      shelter_id: 1
      )

    @petapplication_1 = PetApplication.create!(application_id: @application_1.id, pet_id: @pet_1.id)
    @petapplication_2 = PetApplication.create!(application_id: @application_1.id, pet_id: @pet_2.id)

    @petapplication_3 = PetApplication.create!(application_id: @application_2.id, pet_id: @pet_1.id)
    @petapplication_4 = PetApplication.create!(application_id: @application_2.id, pet_id: @pet_2.id)

    visit "/admin/applications/#{@application_1.id}"
  end

  it "can approve a pet" do
    @application_1.pets.each do |pet|
      within "#pending_pets-#{pet.id}" do
        expect(page).to have_content(pet.name)
        expect(page).to have_button("Approve")
        expect(page).to have_button("Reject")
      end
    end
    within "#pending_pets-#{@pet_1.id}" do
      click_button "Approve"
      expect(current_path).to eq("/admin/applications/#{@application_1.id}")
    end

    within "#pending_pets-#{@pet_1.id}" do
      expect(page).to_not have_button("Approve")
      expect(page).to_not have_button("Reject")
      expect(page).to have_content("Approved")
    end
  end

  it "can reject a pet" do
    @application_1.pets.each do |pet|
      within "#pending_pets-#{pet.id}" do
        expect(page).to have_content(pet.name)
        expect(page).to have_button("Reject")
        expect(page).to have_button("Approve")
      end
    end
    within "#pending_pets-#{@pet_1.id}" do
      click_button "Reject"
      expect(current_path).to eq("/admin/applications/#{@application_1.id}")
    end
    within "#pending_pets-#{@pet_1.id}" do
      expect(page).to_not have_button("Approve")
      expect(page).to_not have_button("Reject")
      expect(page).to have_content("Rejected")
    end
  end

  it "can approve a pet on a seperate application" do
    @application_1.pets.each do |pet|
      within "#pending_pets-#{pet.id}" do
        expect(page).to have_content(pet.name)
        expect(page).to have_button("Approve")
        expect(page).to have_button("Reject")
      end
    end
    within "#pending_pets-#{@pet_1.id}" do
      click_button "Approve"
      expect(current_path).to eq("/admin/applications/#{@application_1.id}")
    end
    within "#pending_pets-#{@pet_2.id}" do
      click_button "Reject"
      expect(current_path).to eq("/admin/applications/#{@application_1.id}")
    end
    within "#pending_pets-#{@pet_1.id}" do
      expect(page).to_not have_button("Approve")
      expect(page).to_not have_button("Reject")
      expect(page).to have_content("Approved")
    end
    within "#pending_pets-#{@pet_2.id}" do
      expect(page).to_not have_button("Approve")
      expect(page).to_not have_button("Reject")
      expect(page).to have_content("Rejected")
    end

    visit "/admin/applications/#{@application_2.id}"
    @application_2.pets.each do |pet|
      within "#pending_pets-#{pet.id}" do
        expect(page).to have_content(pet.name)
        expect(page).to have_button("Approve")
        expect(page).to have_button("Reject")
      end
    end
  end
end
