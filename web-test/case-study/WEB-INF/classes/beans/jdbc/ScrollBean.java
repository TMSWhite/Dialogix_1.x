package beans.jdbc;

public class ScrollBean {
	private int position, pageSize;

	public ScrollBean() {
		this(1, 4);
	}
	public ScrollBean(int start, int pageSize) {
		this.position = start;
		this.pageSize = pageSize;
	}
	public synchronized int scroll(String direction) {
		if("fwd".equalsIgnoreCase(direction)) {
			position += pageSize + 1;
		}
		else if("back".equalsIgnoreCase(direction)) {
			position -= pageSize;
			position = (position < 1) ? 1 : position;	
		}
		else
			position = 1;

		return position;
	}
	public synchronized void setPosition(int position) {
		this.position = position;
	}
	public synchronized void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}
	public synchronized int getPosition() {
		return position;
	}
	public synchronized int getEndPosition() {
		return position + pageSize;
	}
}
