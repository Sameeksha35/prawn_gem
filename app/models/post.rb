class Post < ApplicationRecord
    validates :title,presence: true,uniqueness: true
    validates :description,presence: true
    has_one_attached :cover_image

    def generate_post_pdf
        post_pdf = Prawn::Document.new
   
        post_pdf.repeat(:all) do
            post_pdf.bounding_box([post_pdf.bounds.left,post_pdf.bounds.top],width: post_pdf.bounds.width) do
                post_pdf.text 'Blogging App',size: 40,style: :bold, align: :center
                post_pdf.stroke_horizontal_rule
            end

            post_pdf.bounding_box([post_pdf.bounds.left,post_pdf.bounds.bottom + 30],width: post_pdf.bounds.width) do
                post_pdf.stroke_horizontal_rule
                post_pdf.move_down 5
                post_pdf.text 'Blogging App Footer',size: 20,style: :bold, align: :center
            end
        end

        post_pdf.bounding_box([post_pdf.bounds.left,post_pdf.bounds.top - 60 ],width: post_pdf.bounds.width,height: post_pdf.bounds.height - 100) do
        post_pdf.text title,size: 30,style: :bold,align: :center
        # post_pdf.move_down 100
        post_pdf.image StringIO.open(cover_image.download),at:[20,580],width: 500 
        post_pdf.move_down 300
        post_pdf.text description
        end

        post_pdf
    end
end
