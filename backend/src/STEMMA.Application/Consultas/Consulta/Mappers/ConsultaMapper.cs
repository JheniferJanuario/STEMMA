using STEMMA.Application.Consultas.DTOs.Responses;
using STEMMA.Domain.Consultas.Entities;

namespace STEMMA.Application.Consultas.Mappers;

public static class ConsultaMapper
{
    public static ConsultationResponse ParaResposta(Consulta consulta)
    {
        if (consulta is null)
            throw new Exception("Consulta inválida");

        return new ConsultationResponse
        {
            Id = consulta.Id,
            PetId = consulta.PetId,
            VeterinarianId = consulta.VeterinarioId,
            DateTime = consulta.DataConsulta,
            Status = consulta.Status.ToString()
        };
    }

    public static List<ConsultationResponse> ParaListaResposta(List<Consulta> consultas)
    {
        return consultas.Select(ParaResposta).ToList();
    }
}