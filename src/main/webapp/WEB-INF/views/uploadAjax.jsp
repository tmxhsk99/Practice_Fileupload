<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
	.uploadResult{
		width:100%;
		background-color : grey;
	}
	
	.uploadResult ul {
		display:flex;
		flex-flow: row;
		justify-content : center;
		align-items: center;
	}
	.uploadResult ul li {
		list-style:none;
		padding: 10px;
	}
	.uploadResult ul li img{
		width : 20px;
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
	$(document).ready(function(){

		//업로드한 일반파일의 아이콘을 출력시키는 함수 
		
		var uploadResult = $(".uploadResult ul");
		function showUploadedFile(uploadResultArr){
			var str="";
			$(uploadResultArr).each(
					function(i, obj) {

						if (!obj.image) {
							str += "<li><img src='/resources/img/attach.png'>"
									+ obj.fileName + "</li>";
						} else {
							//str += "<li>" + obj.fileName + "</li>";
							var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_"+obj.uuid+"_"+obj.fileName);
							
							str+="<li><img src='/display?fileName="+fileCallPath+"'><li>";
						}
					});

			uploadResult.append(str);
		}
		
		//업로드 파일 사이즈와 압축파일 예외처리
		var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
		var maxSize = 5242880; //5MB
		function checkExtension(fileName , fileSize){
			if(fileSize >= maxSize){
				alert("파일 사이즈 초과");
				return false;
			}
			if(regex.test(fileName)){
				alert("해당 종류의 파일은 업로드 할 수 없습니다.");
				return false;
			}
			return true;
		}
		//업로드 파일 초기화
		var cloneObj = $(".uploadDiv").clone();
		
		//업로드 버튼 클릭시
			$("#uploadBtn").on("click", function(e){
				
				var formData = new FormData();
				
				var inputFile = $("input[name='uploadFile']");
				
				var files = inputFile[0].files;
				
				console.log(files);
				
				//add filedata to formdata
				for(var i = 0; i < files.length; i++){
					
					if(!checkExtension(files[i].name, files[i].size) ){
						return false;
					}
					
					formData.append("uploadFile",files[i]);
				}
		
			
			$.ajax({
				url: '/uploadAjaxAction',
				processData: false, 
				contentType: false,
				data: formData,
				type: 'POST',
				dataType: 'json',
				success: function(result) {
					console.log(result);
					
					showUploadedFile(result);
					
					$(".uploadDiv").html(cloneObj.html());
				}
			});//$.ajax
		});
	});
	</script>

</body>
</html>