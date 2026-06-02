namespace STEMMA.Application.Consultas.Disponibilidades.DTOs.Requests;

public class CreateAgendaDisponibilidadeRequest
{
    public Guid VeterinarioId { get; set; }

    public DateTime Data { get; set; }

    public TimeSpan HoraInicio { get; set; }

    public TimeSpan HoraFim { get; set; }

    public int DuracaoMinutos { get; set; } = 60;
}