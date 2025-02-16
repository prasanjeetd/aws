document.addEventListener("DOMContentLoaded", function () {
    const employeeListContainer = document.getElementById("employeeList");
  
    fetch("http://localhost:4000/employees")
      .then(response => {
        if (!response.ok) {
          throw new Error(`HTTP error! Status: ${response.status}`);
        }
        return response.json();
      })
      .then(data => {
        if (!data || data.length === 0) {
          employeeListContainer.innerHTML = "<p>No employees found.</p>";
        } else {
          let tableHTML = `
            <table>
              <thead>
                <tr>
                  <th>Name</th>
                  <th>Email</th>
                  <th>Age</th>
                  <th>Department</th>
                </tr>
              </thead>
              <tbody>
          `;
          data.forEach(employee => {
            tableHTML += `
              <tr>
                <td>${employee.name}</td>
                <td>${employee.email}</td>
                <td>${employee.age}</td>
                <td>${employee.department}</td>
              </tr>
            `;
          });
          tableHTML += `
              </tbody>
            </table>
          `;
          employeeListContainer.innerHTML = tableHTML;
        }
      })
      .catch(error => {
        console.error("Error fetching employees:", error);
        employeeListContainer.innerHTML = "<p>Error loading employees.</p>";
      });
  });
  