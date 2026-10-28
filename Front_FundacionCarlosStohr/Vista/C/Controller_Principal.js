import { Notifications } from "../Modelo/Utils/Notifications.js";

(async function() {
    if (document.body.id === 'Principal') {
        try {
            // Fetch total participants
            const resParticipantes = await fetch("http://localhost:3002/Participantes/Getusuarios");
            if (resParticipantes.ok) {
                const participantes = await resParticipantes.json();
                const totalParticipantesEl = document.getElementById("total_participantes");
                if (totalParticipantesEl) {
                    totalParticipantesEl.textContent = participantes.length || 0;
                }
            }

            // Fetch total concursos
            const resConcursos = await fetch("http://localhost:3002/Concurso/Getconcursos");
            if (resConcursos.ok) {
                const concursos = await resConcursos.json();
                const totalConcursosEl = document.getElementById("total_concursos");
                if (totalConcursosEl) {
                    totalConcursosEl.textContent = concursos.length || 0;
                }
            }

        } catch (error) {
            console.error("Error loading dashboard data:", error);
            // Notifications.error("Error al cargar los datos del dashboard.");
        }
    }
})();
