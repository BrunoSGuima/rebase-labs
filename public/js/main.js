fetch('/exams')
    .then(response => response.json())
    .then(data => {
      const examsTable = document.querySelector('#exams tbody');
      data.forEach(exam => {
        const tr = document.createElement('tr');

        ['result_token', 'name', 'cpf', 'email', 'birthday', 'result_date', 
        'doctor.name', 'doctor.crm', 'doctor.crm_state'].forEach(key => {
          const td = document.createElement('td');
          const [objectKey, subKey] = key.split('.');
          
          if (key === 'result_date' || key === 'birthday') {
            td.textContent = new Date(subKey ? exam[objectKey][subKey] : exam[key]).toLocaleDateString('pt-BR', { timeZone: 'UTC' });
          } else {
            td.textContent = subKey ? exam[objectKey][subKey] : exam[key];
          }

          tr.appendChild(td);
        });

        const tdDetails = document.createElement('td');
        const detailsLink = document.createElement('a');
        detailsLink.href = '/exams/' + exam.result_token + '/data';
        detailsLink.textContent = 'Detalhes';
        tdDetails.appendChild(detailsLink);
        tr.appendChild(tdDetails);

        examsTable.appendChild(tr);
      });
    });