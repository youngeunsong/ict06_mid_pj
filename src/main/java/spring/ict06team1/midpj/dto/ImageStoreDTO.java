package spring.ict06team1.midpj.dto;

import java.sql.Timestamp;

public class ImageStoreDTO {

	private int image_id;
	private int target_id;
	private String target_type;
	private String image_url;
	private String is_representative;
	private int sort_order;
	private Timestamp imgUploadDate;
	
	public ImageStoreDTO() {
		super();
	}

	public ImageStoreDTO(int image_id, int target_id, String target_type, String image_url, String is_representative,
			int sort_order, Timestamp imgUploadDate) {
		super();
		this.image_id = image_id;
		this.target_id = target_id;
		this.target_type = target_type;
		this.image_url = image_url;
		this.is_representative = is_representative;
		this.sort_order = sort_order;
		this.imgUploadDate = imgUploadDate;
	}
	
	public int getImage_id() {
		return image_id;
	}
	public void setImage_id(int image_id) {
		this.image_id = image_id;
	}
	public int getTarget_id() {
		return target_id;
	}
	public void setTarget_id(int target_id) {
		this.target_id = target_id;
	}
	public String getTarget_type() {
		return target_type;
	}
	public void setTarget_type(String target_type) {
		this.target_type = target_type;
	}
	public String getImage_url() {
		return image_url;
	}
	public void setImage_url(String image_url) {
		this.image_url = image_url;
	}
	public String getIs_representative() {
		return is_representative;
	}
	public void setIs_representative(String is_representative) {
		this.is_representative = is_representative;
	}
	public int getSort_order() {
		return sort_order;
	}
	public void setSort_order(int sort_order) {
		this.sort_order = sort_order;
	}
	public Timestamp getImgUploadDate() {
		return imgUploadDate;
	}
	public void setImgUploadDate(Timestamp imgUploadDate) {
		this.imgUploadDate = imgUploadDate;
	}

	@Override
	public String toString() {
		return "ImageStoreDTO [image_id=" + image_id + ", target_id=" + target_id + ", target_type=" + target_type
				+ ", image_url=" + image_url + ", is_representative=" + is_representative + ", sort_order=" + sort_order
				+ ", imgUploadDate=" + imgUploadDate + "]";
	}
	
}
