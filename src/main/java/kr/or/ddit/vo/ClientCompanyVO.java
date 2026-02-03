package kr.or.ddit.vo;

import lombok.Data;

@Data
public class ClientCompanyVO {
	 private String companyNo;
	 private String companyName;
	 private String companyAddr1;
	 private String companyAddr2;
	 private int companyPostcode;
	 private String companyCeoName;
	 private String companyAuthStatus;
	 private int bizFileNo;
}
