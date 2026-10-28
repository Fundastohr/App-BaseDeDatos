/**
 * Utilidad para mostrar notificaciones modernas usando SweetAlert2
 * Reemplaza los alert() tradicionales con notificaciones más elegantes
 */

class Notifications {
  /**
   * Muestra una notificación de éxito
   * @param {string} message - Mensaje a mostrar
   * @param {string} title - Título opcional (por defecto "¡Éxito!")
   */
  static success(message, title = "¡Éxito!") {
    Swal.fire({
      icon: "success",
      title: title,
      text: message,
      confirmButtonText: "Aceptar",
      confirmButtonColor: "#28a745",
      timer: 3000,
      timerProgressBar: true,
      toast: false,
      position: "top-end",
      showConfirmButton: true,
    });
  }

  /**
   * Muestra una notificación de error
   * @param {string} message - Mensaje a mostrar
   * @param {string} title - Título opcional (por defecto "Error")
   */
  static error(message, title = "Error") {
    Swal.fire({
      icon: "error",
      title: title,
      text: message,
      confirmButtonText: "Aceptar",
      confirmButtonColor: "#dc3545",
      toast: false,
      position: "top-end",
      showConfirmButton: true,
    });
  }

  /**
   * Muestra una notificación de advertencia
   * @param {string} message - Mensaje a mostrar
   * @param {string} title - Título opcional (por defecto "Advertencia")
   */
  static warning(message, title = "Advertencia") {
    Swal.fire({
      icon: "warning",
      title: title,
      text: message,
      confirmButtonText: "Aceptar",
      confirmButtonColor: "#ffc107",
      toast: false,
      position: "top-end",
      showConfirmButton: true,
    });
  }

  /**
   * Muestra una notificación de información
   * @param {string} message - Mensaje a mostrar
   * @param {string} title - Título opcional (por defecto "Información")
   */
  static info(message, title = "Información") {
    Swal.fire({
      icon: "info",
      title: title,
      text: message,
      confirmButtonText: "Aceptar",
      confirmButtonColor: "#17a2b8",
      timer: 3000,
      timerProgressBar: true,
      toast: false,
      position: "top-end",
      showConfirmButton: true,
    });
  }

  /**
   * Muestra un diálogo de confirmación
   * @param {string} message - Mensaje a mostrar
   * @param {string} title - Título opcional (por defecto "¿Estás seguro?")
   * @returns {Promise<boolean>} - Promise que resuelve a true si se confirma, false si se cancela
   */
  static async confirm(message, title = "¿Estás seguro?") {
    const result = await Swal.fire({
      title: title,
      text: message,
      icon: "question",
      showCancelButton: true,
      confirmButtonColor: "#28a745",
      cancelButtonColor: "#dc3545",
      confirmButtonText: "Sí, continuar",
      cancelButtonText: "Cancelar",
      reverseButtons: true,
    });

    return result.isConfirmed;
  }

  /**
   * Muestra una notificación tipo toast (más pequeña y discreta)
   * @param {string} message - Mensaje a mostrar
   * @param {string} type - Tipo: 'success', 'error', 'warning', 'info'
   */
  static toast(message, type = "success") {
    const Toast = Swal.mixin({
      toast: true,
      position: "top-end",
      showConfirmButton: false,
      timer: 3000,
      timerProgressBar: true,
      didOpen: (toast) => {
        toast.addEventListener("mouseenter", Swal.stopTimer);
        toast.addEventListener("mouseleave", Swal.resumeTimer);
      },
    });

    Toast.fire({
      icon: type,
      title: message,
    });
  }
}

export { Notifications };
