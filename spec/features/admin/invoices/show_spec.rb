require 'rails_helper'

describe 'As an visitor' do
  describe 'When i visit an admin invoice show apge' do
    before :each do
      @merchant = create(:merchant)

      @customer_1 = create(:customer)

      @invoice_1 = create(:invoice, customer: @customer_1, merchant: @merchant, status: 0)

      @item = create(:item, merchant: @merchant)
      @item2 = create(:item, merchant: @merchant)

      @invoice_item = create(:invoice_item, item: @item, invoice: @invoice_1, status: 0)
      @invoice_item2 = create(:invoice_item, item: @item2, invoice: @invoice_1, status: 0)
    end

    it 'I see the invoices attributes' do
      visit admin_invoice_path(@invoice_1)

      within("#invoice-info") do
        expect(page).to have_content(@invoice_1.date)
        expect(page).to have_content(@invoice_1.total_revenue.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse)
      end
    end

    it 'I see the customer info pertaining to the invoice' do
      visit admin_invoice_path(@invoice_1)

      within("#customer-info") do
        expect(page).to have_content("#{@invoice_1.customer_name}")
        expect(page).to have_content("123 Drury Ln")
        expect(page).to have_content("Nowhere, ID 10001")
      end
    end

    it 'I can update the invoices status' do
      visit admin_invoice_path(@invoice_1)

      within("#update-status") do
        expect(page).to have_content("Cancelled")
        
        select("Completed", :from => "invoice[status]")
        
        click_button "Update Invoice"
        
        expect(page).to have_content("Completed")
      end

      expect(page).to have_content("Invoice successfully updated")
    end
  end
end
