window.addEventListener('load', function() {
  var token = window.location.pathname.split('/')[2];

  fetch('/exams/' + token)
    .then(response => {
      if (!response.ok) {
        throw new Error('Nenhum exame encontrado');
      }
      return response.json();
    })
    .then(data => {
      const examDetailsDiv = document.getElementById('examDetails');

      let patientDetailsDiv = document.createElement('div');
      patientDetailsDiv.className = 'row';

      let patientDetailsCol = document.createElement('div');
      patientDetailsCol.className = 'col';
      patientDetailsDiv.appendChild(patientDetailsCol);

      let patientHeader = document.createElement('h2');
      patientHeader.textContent = 'Paciente';
      patientDetailsCol.appendChild(patientHeader);

      let patientTable = document.createElement('table');
      patientTable.className = 'table table-striped';
      
      let patientThead = document.createElement('thead');
      let patientTbody = document.createElement('tbody');
      patientTable.appendChild(patientThead);
      patientTable.appendChild(patientTbody);

      patientDetailsCol.appendChild(patientTable);

      let patientDetails = [
        ['Nome', data.Paciente.paciente_nome],
        ['Data de Nascimento', new Date(data.Paciente.paciente_data_nascimento).toLocaleDateString('pt-BR', { timeZone: 'UTC' })],
        ['Endereço', data.Paciente.paciente_endereco],
        ['Cidade', data.Paciente.paciente_cidade],
        ['Estado', data.Paciente.paciente_estado],
      ];

      patientDetails.forEach(([label, value]) => {
        let row = document.createElement('tr');
        let labelCell = document.createElement('td');
        let valueCell = document.createElement('td');

        labelCell.textContent = label;
        valueCell.textContent = value;

        row.appendChild(labelCell);
        row.appendChild(valueCell);
        patientTbody.appendChild(row);
      });

      let doctorDetailsCol = document.createElement('div');
      doctorDetailsCol.className = 'col';
      patientDetailsDiv.appendChild(doctorDetailsCol);

      let doctorHeader = document.createElement('h2');
      doctorHeader.textContent = 'Médico';
      doctorDetailsCol.appendChild(doctorHeader);

      let doctorTable = document.createElement('table');
      doctorTable.className = 'table table-striped';

      let doctorThead = document.createElement('thead');
      let doctorTbody = document.createElement('tbody');
      doctorTable.appendChild(doctorThead);
      doctorTable.appendChild(doctorTbody);

      doctorDetailsCol.appendChild(doctorTable);

      let doctorDetails = [
        ['Nome', data.Médico.medico_nome],
        ['CRM', data.Médico.medico_crm],
        ['Estado do CRM', data.Médico.medico_crm_estado],
        ['Email', data.Médico.medico_email],
      ];

      doctorDetails.forEach(([label, value]) => {
        let row = document.createElement('tr');
        let labelCell = document.createElement('td');
        let valueCell = document.createElement('td');

        labelCell.textContent = label;
        valueCell.textContent = value;

        row.appendChild(labelCell);
        row.appendChild(valueCell);
        doctorTbody.appendChild(row);
      });

      examDetailsDiv.appendChild(patientDetailsDiv);

      let examHeader = document.createElement('h2');
      examHeader.textContent = 'Resultados';
      examDetailsDiv.appendChild(examHeader);

      let examTableDiv = document.createElement('div');
      examTableDiv.className = 'table-responsive';
      examDetailsDiv.appendChild(examTableDiv);

      let examTable = document.createElement('table');
      examTable.className = 'table table-striped';
      examTableDiv.appendChild(examTable);

      let examThead = document.createElement('thead');
      let examTbody = document.createElement('tbody');
      examTable.appendChild(examThead);
      examTable.appendChild(examTbody);

      let examHeaders = document.createElement('tr');
      examThead.appendChild(examHeaders);

      ['Tipo', 'Limites', 'Resultado', ''].forEach(header => {
        let th = document.createElement('th');
        th.scope = 'col';
        th.textContent = header;
        examHeaders.appendChild(th);
      });

      data.Exames.Resultados.forEach(result => {
        let parts = result.split(', ');
        let tipo = parts[0].split(': ')[1];
        let limites = parts[1].split(': ')[1];
        let resultado = parseInt(parts[2].split(': ')[1]);

        let limitesParts = limites.split('-');
        let lowerLimit = parseInt(limitesParts[0]);
        let upperLimit = parseInt(limitesParts[1]);

        let icon = document.createElement('i');
        icon.className = 'bi bi-exclamation-diamond-fill text-danger';
        if (resultado >= lowerLimit && resultado <= upperLimit) {
          icon.className = 'bi bi-check-circle-fill text-success';
        }

        let row = document.createElement('tr');
        [tipo, limites, resultado, icon].forEach(content => {
          let td = document.createElement('td');
          if (content instanceof HTMLElement) {
            td.appendChild(content);
          } else {
            td.textContent = content.toString();
          }
          row.appendChild(td);
        });

        examTbody.appendChild(row);
      });

    })
    .catch(error => {
      console.error('Erro:', error);
    });
});

