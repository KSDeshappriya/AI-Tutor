# 📘 TuteAI Course Generator API Documentation

**Version:** 2.0.0
**Base URL:** *[http://localhost:8000/](http://localhost:8000/)*
**OpenAPI Version:** 3.1.0
**Description:** AI-powered course generation system.

---

## 📂 API Endpoints

---

## 🔄 `/api/versions`

**GET**
**Summary:** Retrieve available API versions.
**Response:**

* `200 OK` – JSON object with version information.

---

## ✅ API v1 Endpoints

### 📌 `/api/v1/plan-course`

**POST**
**Summary:** Plan a new course.
**Request Body:** `CourseRequest`
**Response:**

* `200 OK`: `CourseResponse`
* `422 Unprocessable Entity`: `HTTPValidationError`

---

### 📌 `/api/v1/plan-module`

**POST**
**Summary:** Plan a module for a course.
**Request Body:** `ModuleRequest`
**Response:**

* `200 OK`: `ModuleResponse`
* `422 Unprocessable Entity`: `HTTPValidationError`

---

### 📌 `/api/v1/create-lesson-content`

**POST**
**Summary:** Generate content for a lesson.
**Request Body:** `LessonRequest`
**Response:**

* `200 OK`: `LessonResponse`
* `422 Unprocessable Entity`: `HTTPValidationError`

---

### 📌 `/api/v1/create-quiz`

**POST**
**Summary:** Create a quiz for a lesson.
**Request Body:** `LessonRequest`
**Response:**

* `200 OK`: `QuizResponse`
* `422 Unprocessable Entity`: `HTTPValidationError`

---

### 📌 `/api/v1/documents/upload`

**POST**
**Summary:** Upload and process a document.
**Content-Type:** `multipart/form-data`
**Field:** `file` (binary)
**Response:**

* `200 OK`: `DocumentUploadResponse`
* `422 Unprocessable Entity`: `HTTPValidationError`

---

### 📌 `/api/v1/documents/{document_id}`

**GET**
**Summary:** Retrieve content of a document by ID.
**Path Parameter:** `document_id: string`
**Response:**

* `200 OK`: JSON content
* `422 Unprocessable Entity`: `HTTPValidationError`

---

### 📌 `/api/v1/document-courses/generate-course`

**POST**
**Summary:** Generate a course from an uploaded document.
**Request Body:** `DocumentCourseRequest`
**Response:**

* `200 OK`: `CourseResponse`
* `422 Unprocessable Entity`: `HTTPValidationError`

---

### 📌 `/api/v1/document-courses/generate-module`

**POST**
**Summary:** Generate a module from a document.
**Request Body:** `DocumentModuleRequest`
**Response:**

* `200 OK`: `ModuleResponse`
* `422 Unprocessable Entity`: `HTTPValidationError`

---

### 📌 `/api/v1/document-courses/generate-lesson`

**POST**
**Summary:** Generate a lesson from a document.
**Request Body:** `DocumentLessonRequest`
**Response:**

* `200 OK`: `LessonResponse`
* `422 Unprocessable Entity`: `HTTPValidationError`

---

### 📌 `/api/v1/document-courses/generate-quiz`

**POST**
**Summary:** Generate a quiz from a document.
**Request Body:** `DocumentQuizRequest`
**Response:**

* `200 OK`: `List[QuizQuestion]`
* `422 Unprocessable Entity`: `HTTPValidationError`

---

## ✅ API v2 Endpoints

### 📌 `/api/v2/`

**GET**
**Summary:** API v2 root endpoint.
**Response:**

* `200 OK`: API info

---

### 📌 `/api/v2/plan-course`

**POST**
**Summary:** Plan a course with enhanced options.
**Request Body:** `app__models__v2__course__CourseRequest`
**Response:**

* `201 Created`: `CourseResponse`
* `422 Unprocessable Entity`: `HTTPValidationError`

---

### 📌 `/api/v2/export-course/{course_id}`

**GET**
**Summary:** Export course in a specified format.
**Path Parameter:** `course_id: string`
**Query Parameter:** `format: string` (optional: `md`, `html`, `pdf`)
**Response:**

* `200 OK`: File content or JSON
* `422 Unprocessable Entity`: `HTTPValidationError`

---

### 📌 `/api/v2/plan-module`

**POST**
**Summary:** Plan a module under a specific course.
**Request Body:** `ModuleRequest`
**Response:**

* `200 OK`: `ModuleResponse`
* `422 Unprocessable Entity`: `HTTPValidationError`

---

### 📌 `/api/v2/create-lesson-content`

**POST**
**Summary:** Create rich content for a lesson.
**Request Body:** `LessonRequest`
**Response:**

* `200 OK`: `LessonResponse`
* `422 Unprocessable Entity`: `HTTPValidationError`

---

### 📌 `/api/v2/create-quiz`

**POST**
**Summary:** Generate an advanced quiz for a lesson.
**Request Body:** `QuizRequest`
**Response:**

* `200 OK`: `QuizResponse`
* `422 Unprocessable Entity`: `HTTPValidationError`

---

### 📌 `/api/v2/health`

**GET**
**Summary:** Health check endpoint.
**Response:**

* `200 OK`: API status

---

### 📌 `/api/v2/feedback`

**POST**
**Summary:** Submit feedback on generated content.
**Request Body:** `Feedback (free-form JSON)`
**Response:**

* `201 Created`
* `422 Unprocessable Entity`: `HTTPValidationError`

---

### 📌 `/api/v2/generate-learning-path`

**POST**
**Summary:** Generate a personalized learning path.
**Request Body:** Custom JSON with user goals and background.
**Response:**

* `201 Created`
* `422 Unprocessable Entity`: `HTTPValidationError`

---

### 📌 `/api/v2/debug`

**POST**
**Summary:** Debug and test AI behaviors.
**Request Body:** JSON (flexible input)
**Response:**

* `200 OK`: JSON output
* `422 Unprocessable Entity`: `HTTPValidationError`


## With Examples

 - v1 API Endpoints: [v1: Check](V1.md)
 - V2 API Endpoints: [v2: Check](V2.md)