using STEMMA.Application.Consultas.DTOs.Responses;
using STEMMA.Domain.Consultas.Repositories;

namespace STEMMA.Application.Consultas.UseCases;

public class GetConsultationByIdUseCase
{
    private readonly IConsultaRepository _consultaRepository;

    public GetConsultationByIdUseCase(IConsultaRepository consultaRepository)
    {
        _consultaRepository = consultaRepository;
    }

    public async Task<ConsultationResponse?> ExecuteAsync(Guid id)
    {
        var consulta = await _consultaRepository.ObterPorIdAsync(id);

        if (consulta is null)
            return null;

        return new ConsultationResponse
        {
            Id = consulta.Id,
            PetId = consulta.PetId,
            VeterinarianId = consulta.VeterinarioId,
            DateTime = consulta.DataConsulta,
            Status = consulta.Status.ToString()
        };
    }
}