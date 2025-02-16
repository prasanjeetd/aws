// Select the form element
const employeeForm = document.getElementById('employeeForm');

employeeForm.addEventListener('submit', function (event) {
  event.preventDefault(); // Prevent the default form submission behavior

  // Gather form data into an object
  const formData = new FormData(employeeForm);
  const data = {};
  formData.forEach((value, key) => {
    data[key] = value;
  });

  // Define the remote backend API endpoint
  const apiUrl = 'http://localhost:4000/employees'; // Replace with your actual backend URL

  // Submit the form data using the Fetch API
  fetch(apiUrl, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(data)
  })
    .then(response => {
      if (!response.ok) {
        throw new Error(`HTTP error! Status: ${response.status}`);
      }
      return response.json();
    })
    .then(result => {
      // On a successful submission, navigate to the employees list page
      window.location.href = 'employees.html';
    })
    .catch(error => {
      // Handle errors
      document.getElementById('response').innerText =
        'There was an error submitting the form.';
      console.error('Error:', error);
    });
});
