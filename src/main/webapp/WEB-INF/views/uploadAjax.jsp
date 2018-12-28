<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<div class='bigPictureWrapper'>
  <div class='bigPicture'>
  </div>
</div>
<style type="text/css">
.uploadResult {
	width: 100%;
	background-color: gray;
}

.uploadResult ul {
	display: flex;
	flex-flow: row;
	justify-content: center;
	align-items: center;
}

.uploadResult ul li {
	list-style: none;
	padding: 10px;
}

.uploadResult ul li img {
	width: 100px;
}
/* 이미지 클릭시 크게  */
.bigPictureWrapper {
  position: absolute;
  display: none;
  justify-content: center;
  align-items: center;
  top:0%;
  width:100%;
  height:100%;
  background-color: gray; 
  z-index: 100;
}

.bigPicture {
  position: relative;
  display:flex;
  justify-content: center;
  align-items: center;
}
</style>

</head>
<body>

	<h1>Upload with Ajax</h1>

	<div class='uploadDiv'>
		<input type='file' name='uploadFile' multiple>
	</div>
	<div class='uploadResult'>
		<ul>

		</ul>
	</div>

	<button id='uploadBtn'>Upload</button>

	<script
		src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	<script>
		function showImage(fileCallPath){
		  
		  //alert(fileCallPath);
		
		  $(".bigPictureWrapper").css("display","flex").show();
		  //원본 이미지 띄우기 
		  $(".bigPicture")
		  .html("<img src='/display?fileName="+fileCallPath+"'>")
		  .animate({width:'100%', height: '100%'}, 1000);
		 	//다시 이미지를 없앰
		  $(".bigPictureWrapper").on("click",function(e){
			  $(".bigPicture").animate({width:'0%',height:'0%'}, 1000);
			  setTimeout( () => {
				 $(this).hide(); 
			  },1000);
		  });
		}
		//x표시 이벤트 처리 
		$(".uploadResult").on("click","span",function(e){
			var targetFile = $(this).data("file");
			var type = $(this).data("type");
			console.log(targetFile);
			
			$.ajax({
				url: '/deleteFile',
				data: {fileName : targetFile , type:type},
				dataType : 'text',
				type: 'POST',
				success:function(result){
					alert(result);
				}
			});//ajax;
		});
	
		$(document).ready(function() {

							//업로드한 일반파일 아이콘 및 이미지는 섬네일 을 출력시키는 함수 

							var uploadResult = $(".uploadResult ul");
							
							function showUploadedFile(uploadResultArr) {
								
								var str = "";
								
								$(uploadResultArr)
										.each(
												function(i, obj) {

													if (!obj.image) {
														var fileCallPath = encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
																
														str += "<li><div><a href='/download?fileName="+fileCallPath+"'>"
															+"<img src='/resources/img/attach.png'>"+obj.fileName +"</a>"+
															"<span data-file=\'"+ fileCallPath +"\' data-type='file'> x </span>"+
															"<div></li>";
													} else {
														//str += "<li>" + obj.fileName + "</li>";
														//파일 위치+섬네일 표시 + uuid + filename
														var fileCallPath = encodeURIComponent(obj.uploadPath+ "/s_"+ obj.uuid+ "_"
																+ obj.fileName);
														//오리지널 이미지 위치와 이름
														var originPath = obj.uploadPath+"\\"+obj.uuid+"_"+obj.fileName;
														
														originPath = originPath.replace(new RegExp(/\\/g),"/");
														
														str += "<li><a href=\"javascript:showImage(\'"+ originPath +"\')\"><img src='/display?fileName="+fileCallPath+"'></a>"+
																"<span data-file =\'" + fileCallPath+"\' data-type='image'> x </span>"+
																"<li>";
													}
												});

								uploadResult.append(str);
							}

							//업로드 파일 사이즈와 압축파일 예외처리
							var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
							var maxSize = 5242880; //5MB
							function checkExtension(fileName, fileSize) {
								if (fileSize >= maxSize) {
									alert("파일 사이즈 초과");
									return false;
								}
								if (regex.test(fileName)) {
									alert("해당 종류의 파일은 업로드 할 수 없습니다.");
									return false;
								}
								return true;
							}
							//업로드 파일 초기화
							var cloneObj = $(".uploadDiv").clone();

							//업로드 버튼 클릭시
							$("#uploadBtn")
									.on(
											"click",
											function(e) {

												var formData = new FormData();

												var inputFile = $("input[name='uploadFile']");

												var files = inputFile[0].files;

												console.log(files);

												//add filedata to formdata
												for (var i = 0; i < files.length; i++) {

													if (!checkExtension(
															files[i].name,
															files[i].size)) {
														return false;
													}

													formData.append(
															"uploadFile",
															files[i]);
												}

												$
														.ajax({
															url : '/uploadAjaxAction',
															processData : false,
															contentType : false,
															data : formData,
															type : 'POST',
															dataType : 'json',
															success : function(
																	result) {
																console
																		.log(result);

																showUploadedFile(result);

																$(".uploadDiv")
																		.html(
																				cloneObj
																						.html());
															}
														});//$.ajax
											});
						});
	</script>

</body>
</html>