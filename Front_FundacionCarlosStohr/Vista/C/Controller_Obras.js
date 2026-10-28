// C/Controller_Obras.js
import { Request_Obra } from "../Modelo/Request/Request_Obras.js";
import { Notifications } from "../Modelo/Utils/Notifications.js";

const onReady = (fn) => {
  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", fn, { once: true });
  } else {
    fn();
  }
};

function setButtonLoading(btn, isLoading, loadingText = "Guardando...") {
  if (!btn) return;

  const textEl = btn.querySelector(".cs-btn-text") || btn;
  if (!btn.dataset.originalHtml) btn.dataset.originalHtml = textEl.innerHTML;

  if (isLoading) {
    btn.disabled = true;
    textEl.innerHTML = `
      <span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>
      ${loadingText}
    `;
  } else {
    btn.disabled = false;
    textEl.innerHTML = btn.dataset.originalHtml;
  }
}

function focusFirstInvalid(form) {
  const firstInvalid = form.querySelector(":invalid");
  if (firstInvalid) {
    firstInvalid.scrollIntoView({ behavior: "smooth", block: "center" });
    setTimeout(() => firstInvalid.focus({ preventScroll: true }), 150);
  }
}

(function () {
  const bodyId = document.body?.id ?? "";

  switch (bodyId) {
    case "BodyConsultarObras": {
      const R = new Request_Obra();
      window.requestObra = R;

      onReady(async () => {
        try {
          await R.cargarObrasEnTabla?.();
        } catch (e) {
          console.error(e);
          Notifications?.error?.(`No se pudo cargar la lista de obras. ${e?.message || ""}`.trim());
        }
      });

      break;
    }

    case "BodyAgregarObra": {
      const R = new Request_Obra();
      window.requestObra = R;

      onReady(() => {
        const form = document.getElementById("form-obra");
        const btnGuardar = document.getElementById("agregarObra");
        const btnLimpiar = document.getElementById("limpiarObra");

        // Sticky (mobile)
        const btnGuardarSticky = document.getElementById("agregarObraSticky");
        const btnLimpiarSticky = document.getElementById("limpiarObraSticky");

        if (!form) return;

        const resetForm = () => {
          form.reset();
          form.classList.remove("was-validated");
          document.getElementById("titulo")?.focus?.();
        };

        btnLimpiar?.addEventListener("click", (e) => {
          e.preventDefault();
          resetForm();
        });
        btnLimpiarSticky?.addEventListener("click", () => resetForm());

        const doSubmit = async () => {
          // Validación HTML + Bootstrap
          if (!form.checkValidity()) {
            form.classList.add("was-validated");
            Notifications?.warning?.("Revisa los campos obligatorios.");
            focusFirstInvalid(form);
            return;
          }

          const payload = R.get_formulario?.();
          if (!payload?.titulo) {
            form.classList.add("was-validated");
            Notifications?.warning?.("El título es obligatorio.");
            focusFirstInvalid(form);
            return;
          }

          // Estado loading en ambos botones
          setButtonLoading(btnGuardar, true);
          setButtonLoading(btnGuardarSticky, true);

          // deshabilita limpiar mientras guarda
          if (btnLimpiar) btnLimpiar.disabled = true;
          if (btnLimpiarSticky) btnLimpiarSticky.disabled = true;

          try {
            const res = await R.agregarObra(payload);
            const id = res?.id_obra ?? res?.id ?? null;

            Notifications?.success?.(
              id ? `Obra agregada correctamente (ID: ${id}).` : "Obra agregada correctamente."
            );

            resetForm();
          } catch (err) {
            console.error(err);
            Notifications?.error?.(`No se pudo agregar la obra. ${err?.message || ""}`.trim());
          } finally {
            setButtonLoading(btnGuardar, false);
            setButtonLoading(btnGuardarSticky, false);

            if (btnLimpiar) btnLimpiar.disabled = false;
            if (btnLimpiarSticky) btnLimpiarSticky.disabled = false;
          }
        };

        // Submit normal (desktop)
        form.addEventListener("submit", async (e) => {
          e.preventDefault();
          e.stopPropagation();
          await doSubmit();
        });

        // Sticky (mobile): dispara submit
        btnGuardarSticky?.addEventListener("click", async () => {
          await doSubmit();
        });

        // Bonus UX: Enter en cualquier input -> submit (sin romper textarea)
        form.addEventListener("keydown", async (e) => {
          if (e.key !== "Enter") return;
          if (e.target && e.target.tagName === "TEXTAREA") return;
          // evita submits raros si se está validando
          e.preventDefault();
          await doSubmit();
        });
      });

      break;
    }

    case "BodyModificarObraCS": {
      const R = new Request_Obra();
      window.requestObra = R;

      onReady(async () => {
        try {
          if (typeof R.cargarObrasModificar === "function") {
            await R.cargarObrasModificar();
          } else {
            await R.cargarObrasEnTabla({ tableSelector: "#tablaObrasCSModificar" });
          }
        } catch (e) {
          console.error(e);
          Notifications?.error?.(`No se pudo cargar la lista de obras (Modificar). ${e?.message || ""}`.trim());
        }

        const tbody = document.querySelector("#tablaObrasCSModificar tbody");
        tbody?.addEventListener("click", (event) => {
          R.ObtenerDatosTablaObrasModificar?.(event);
        });

        document.getElementById("modificarObraCS")?.addEventListener("click", async (e) => {
          e.preventDefault();
          try {
            await R.actualizarObra();
          } catch (err) {
            console.error(err);
            Notifications?.error?.(`No se pudo modificar la obra. ${err?.message || ""}`.trim());
          }
        });
      });

      break;
    }

    case "BodyEliminarObraCS": {
      const R = new Request_Obra();
      window.requestObra = R;

      onReady(async () => {
        try {
          if (typeof R.cargarObrasEliminar === "function") {
            await R.cargarObrasEliminar();
          } else {
            await R.cargarObrasEnTabla({ tableSelector: "#tablaObrasCSEliminar" });
          }
        } catch (e) {
          console.error(e);
          Notifications?.error?.(`No se pudo cargar la lista de obras (Eliminar). ${e?.message || ""}`.trim());
        }

        const tbody = document.querySelector("#tablaObrasCSEliminar tbody");
        tbody?.addEventListener("click", (event) => {
          R.ObtenerDatosTablaObrasEliminar?.(event);
        });

        document.getElementById("eliminarObraCS")?.addEventListener("click", async (e) => {
          e.preventDefault();
          try {
            await R.eliminarObra();
          } catch (err) {
            console.error(err);
            Notifications?.error?.(`No se pudo eliminar la obra. ${err?.message || ""}`.trim());
          }
        });
      });

      break;
    }

    default:
      break;
  }
})();